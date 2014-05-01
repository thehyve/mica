<?php
/**
 * @file
 * mica_export_study.inc
 */
require_once(drupal_get_path('module', 'mica_protobuf') . '/mica_export_query_dto.inc');

function _mica_studies_export_dto_study_dto($nid) {

  $study = array();
  $wrapper = entity_metadata_wrapper('node', $nid);
  $dto_util = new QuerySendDto();

  $study_dto = new obiba\mica\StudyDto;

  $study_dto->setId($wrapper->uuid->value());
  $study_dto->addName($dto_util->_set_LocalizedStringDto($wrapper->title_field->value()));
  $study_acronym = $wrapper->field_acroym->value();
  !empty($study_acronym) ? $study_dto->addAcronym($dto_util->_set_LocalizedStringDto($study_acronym)) : NULL;

  foreach ($wrapper->field_investigators->getIterator() as $investigator_wrapper) {
    if (!empty($investigator_wrapper)) {
      $investigator = _mica_studies_export_dto_contact_dto($dto_util, $investigator_wrapper);
      $study_dto->addInvestigators($investigator);
    }
  }

  $study_dto->addObjectives($dto_util->_set_LocalizedStringDto($wrapper->body->value->value()));
  $study_dto->setWebsite($wrapper->field_website->url->value());

  foreach ($wrapper->field_contacts_ref->getIterator() as $contact_wrapper) {
    if (!empty($contact_wrapper)) {
      $contact = _mica_studies_export_dto_contact_dto($dto_util, $contact_wrapper);
      $study_dto->addContacts($contact);
    }
  }

  $authorization_spec_dto = new \obiba\mica\AuthorizationDto();
  $authorization_spec_dto->setAuthorized($wrapper->field_authorization_specific->value());
  $authorization_spec_dto->setAuthorizer($wrapper->field_authorising_person_name->value());
  $authorization_spec_dto->setDate($wrapper->field_authorising_date->value());
  $study_dto->setSpecificAuthorization($authorization_spec_dto);

  $authorization_maelstrom_dto = new \obiba\mica\AuthorizationDto();
  $authorization_maelstrom_dto->setAuthorized($wrapper->field_authorization_maelstrom->value());
  $authorization_maelstrom_dto->setAuthorizer($wrapper->field_authorising_person_name_m->value());
  $authorization_maelstrom_dto->setDate($wrapper->field_authorising_date_m->value());
  $study_dto->setMaelstromAuthorization($authorization_maelstrom_dto);

  $study_methods_dto = new \obiba\mica\StudyDto\StudyMethodsDto();
  foreach ($wrapper->field_design->getIterator() as $design) {
    $study_methods_dto->addDesigns($design->value());
    if ($design->value() == 'other') {
      $design_other_sp = $wrapper->field_design_other_sp->value->value();
      !empty($design_other_sp) ? $study_methods_dto->addOtherDesign($dto_util->_set_LocalizedStringDto($design_other_sp)) : NULL;
    }
  }
  $info_design_follow_up = $wrapper->field_info_design_follow_up->value->value();
  !empty($info_design_follow_up) ? $study_methods_dto->addFollowUpInfos($dto_util->_set_LocalizedStringDto($info_design_follow_up)) : NULL;

  foreach ($wrapper->field_recruitment->getIterator() as $target) {
    $study_methods_dto->addRecruitments($target->value());
    if ($target->value() == 'other') {
      $recruitment_other_sp = $wrapper->field_recruitment_other_sp->value();
      !empty($recruitment_other_sp) ? $study_methods_dto->addOtherRecruitments($dto_util->_set_LocalizedStringDto($recruitment_other_sp)) : NULL;
    }
  }

  $recruitment_supp_info = $wrapper->field_recruitment_supp_info->value();
  !empty($recruitment_supp_info) ? $study_methods_dto->addInfos($dto_util->_set_LocalizedStringDto($recruitment_supp_info['value'])) : NULL;

  $study_dto->setMethods($study_methods_dto);

  $participant_sample['number'] = $wrapper->field_target_number_participants->value();
  $participant_sample['noLimit'] = $wrapper->field_no_limits_participants->value();
  $biosample['number'] = $wrapper->field_target_number_biosamples->value();
  $biosample['noLimit'] = $wrapper->field_no_limits_samples->value();
  $study_dto->setNumberOfParticipants(
    mica_studies_export_dto_set_number_of_participants($participant_sample,
      $biosample, $wrapper->field_target_nb_supp_info->value()));

  $study_dto->setStartYear($wrapper->field_study_start_year->value());
  $study_dto->setEndYear($wrapper->field_study_end_year->value());

  if ($wrapper->field_access_data->value() == 1) {
    $study_dto->addAccess('data');
  }
  if ($wrapper->field_access_biosamples->value() == 1) {
    $study_dto->addAccess('biosamples');
  }
  if ($wrapper->field_access_other->value() == 1) {
    $access_other_info = $wrapper->field_access_other_sp->value();
    if (!empty($access_other_info)) {
      $study_dto->addOtherAccess($dto_util->_set_LocalizedStringDto($access_other_info['value']));
    }
  }

  $study_dto->setMarkerPaper($wrapper->field_marker_paper->value());
  $study_dto->setPubmedId($wrapper->field_pubmedid->value());

  //@TODO deal with attachement files
/////////////////////////////////////

  $supl_info = $wrapper->field_supp_infos->value();
  !empty($supl_info) ? $study_dto->addInfos($dto_util->_set_LocalizedStringDto($supl_info['value'])) : NULL;

  foreach ($wrapper->field_study_populations->getIterator() as $population_wrapper) {
    if (!empty($population_wrapper)) {
      $population = _mica_studies_export_dto_population_dto($dto_util, $population_wrapper);
      $study_dto->addPopulations($population);
    }
  }

  //TODO Attach networks to study
//  if (module_exists('mica_networks')) {
//    foreach ($wrapper->field_networks->getIterator() as $network_wrapper) {
//      $network = _mica_studies_export_dto_network_dto($dto_util, $network_wrapper);
//    }
//    $study_dto->addNetworks($network);
//  }

  $codec = new \DrSlump\Protobuf\Codec\Binary();
  $data = $study_dto->serialize($codec);
  dpm($study_dto);
  return TRUE;
}

function mica_studies_export_dto_set_number_of_participants($participant = NULL, $sample = NULL, $info = NULL) {
  $participant_dto = new \obiba\mica\StudyDto\NumberOfParticipantsDto();
  $dto_util = new QuerySendDto();
  $participant_dto->setParticipant(mica_studies_export_dto_set_target_number_dto($participant));
  $participant_dto->setSample(mica_studies_export_dto_set_target_number_dto($sample));
  !empty($info) ? $participant_dto->addInfos($dto_util->_set_LocalizedStringDto($info['value'])) : NULL;
  return $participant_dto;
}

function mica_studies_export_dto_set_target_number_dto($target) {
  $target_number = new \obiba\mica\TargetNumberDto();
  $target_number->setNumber($target['number']);
  $target_number->setNoLimit($target['noLimit']);
  return $target_number;
}