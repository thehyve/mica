<?php
/**
 * @file
 * mica_export_population.inc
 */

function _mica_studies_export_dto_population_dto($dto_util, $wrapper) {

  $population_dto = new obiba\mica\StudyDto\PopulationDto();

  $population_dto->addName($dto_util->_set_LocalizedStringDto($wrapper->title_field->value()));
  $population_dto->addDescription($dto_util->_set_LocalizedStringDto($wrapper->body->value->value()));

  $recruitment = new \obiba\mica\StudyDto\PopulationDto\RecruitmentDto();

  foreach ($wrapper->field_pop_src_recruit->getIterator() as $recruit) {
    $recruitment->addDataSources($recruit->value());
    switch ($recruit->value()) {
      case 'general':
        foreach ($wrapper->field_pop_general_pop_recruit->getIterator() as $pop_gen_recrui) {
          $recruitment->addGeneralPopulationSources($pop_gen_recrui->value());
        }
        break;
      case 'exist_studies':
        foreach ($wrapper->field_pop_exist_study_part->getIterator() as $study) {
          $recruitment->addStudies($study->value());
        }
        break;
      case 'specific_population':
        foreach ($wrapper->field_pop_specific_pop->getIterator() as $specific_population) {
          $recruitment->addSpecificPopulationSources($specific_population->value());
          if ($specific_population->value() == 'other') {
            $pop_specific_pop_other_sp = $wrapper->field_pop_specific_pop_other_sp->value();
            !empty($pop_specific_pop_other_sp) ?
              $recruitment->addOtherSpecificPopulationSource($dto_util->_set_LocalizedStringDto($pop_specific_pop_other_sp['value'])) :
              NULL;
          }
        }
        break;
    }
  }
  $sup_info_recrutment = $wrapper->field_pop_recruit_supp_info->value();
  !empty($sup_info_recrutment) ? $recruitment->addInfos($dto_util->_set_LocalizedStringDto($sup_info_recrutment['value'])) : NULL;
  $population_dto->setRecruitment($recruitment);

  $selection_criteria = new obiba\mica\StudyDto\PopulationDto\SelectionCriteriaDto();
  $selection_criteria->setGender($wrapper->field_pop_gender->value());
  $selection_criteria->setAgeMin($wrapper->field_pop_age_min->value());
  $selection_criteria->setAgeMax($wrapper->field_pop_age_max->value());
  foreach ($wrapper->field_pop_country->getIterator() as $country) {
    $selection_criteria->addCountriesIso($country->value());
  }
  $sel_crit_territory = $pop_territory = $wrapper->field_pop_territory->value();
  !empty($sel_crit_territory) ? $selection_criteria->addTerritory($dto_util->_set_LocalizedStringDto($sel_crit_territory['value'])) : NULL;
  foreach ($wrapper->field_pop_select_criteria->getIterator() as $criteria) {
    $selection_criteria->addCriteria($criteria->value());
  }

  foreach ($wrapper->field_pop_ethnic_origin->getIterator() as $ethnic) {
    $ethnic_origin = $ethnic->value();
    if (!empty($ethnic_origin)) {
      $locate_entry = new \obiba\mica\LocalizedStringDtos();
      $selection_criteria->addEthnicOrigin($locate_entry->addLocalizedStrings($dto_util->_set_LocalizedStringDto($ethnic_origin)));
    }
  }

  foreach ($wrapper->field_pop_health_status->getIterator() as $health) {
    $health_status = $health->value();
    if (!empty($health_status)) {
      $locate_entry = new \obiba\mica\LocalizedStringDtos();
      $selection_criteria->addHealthStatus($locate_entry->addLocalizedStrings($dto_util->_set_LocalizedStringDto($health_status)));
    }
  }

  $other_criteria_other_info = $wrapper->field_pop_selection_others_sp->value();
  !empty($other_criteria_other_info) ? $selection_criteria->addOtherCriteria($dto_util->_set_LocalizedStringDto($other_criteria_other_info['value'])) : NULL;

  $other_criteria_sup_info = $wrapper->field_pop_partcipant_sel_supp_in->value();
  !empty($other_criteria_sup_info) ? $selection_criteria->addInfos($dto_util->_set_LocalizedStringDto($other_criteria_sup_info['value'])) : NULL;

  $participant_sample['number'] = $wrapper->field_pop_participants_nb->value();
  $participant_sample['noLimit'] = $wrapper->field_pop_no_limits_participants->value();
  $biosample['number'] = $wrapper->field_pop_participants_nb_s->value();
  $biosample['noLimit'] = $wrapper->field_pop_no_lim_participants_s->value();
  $population_dto->setNumberOfParticipants(
    mica_studies_export_dto_set_number_of_participants($participant_sample,
      $biosample, $wrapper->field_pop_participants_nb_supp_i->value()));

  $population_dto->setSelectionCriteria($selection_criteria);

  $pop_supp_infos = $wrapper->field_pop_supp_infos->value();
  !empty($pop_supp_infos) ? $population_dto->addInfos($dto_util->_set_LocalizedStringDto($pop_supp_infos['value'])) : NULL;

  foreach ($wrapper->field_pop_dce->getIterator() as $dce_wrapper) {
    if (!empty($dce_wrapper)) {
      $dce = _mica_studies_export_dto_dce_dto($dto_util, $dce_wrapper);
      $population_dto->addDataCollectionEvents($dce);
    }
  }

  return $population_dto;
}