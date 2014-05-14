<?php
/**
 * @file
 * mica_export_dce.inc
 */

function _mica_studies_export_dto_dce_dto($dto_util,$wrapper) {
  $population_dto = new obiba\mica\StudyDto\PopulationDto\DataCollectionEventDto();
  $population_dto->addName($dto_util->_set_LocalizedStringDto($wrapper->title_field->value()));
  $population_dto->addDescription($dto_util->_set_LocalizedStringDto($wrapper->body->value->value()));
  $population_dto->setStartYear($wrapper->field_dce_start_year->value());
  $population_dto->setStartMonth($wrapper->field_dce_start_month->value());
  $population_dto->setEndYear($wrapper->field_dce_end_year->value());
  $population_dto->setEndMonth($wrapper->field_dce_end_month->value());

  foreach ($wrapper->field_dce_data_sources->getIterator() as $sources) {
    if (!empty($sources)) {
      $population_dto->addDataSources($sources->value());
      if ($sources->value() == 'others') {
        $population_dto->addOtherDataSources($dto_util->_set_LocalizedStringDto($wrapper->field_dce_data_sources_sp->value()));
      }
      if ($sources->value() == 'biological_samples') {
        foreach ($wrapper->field_dce_bio_samples_management->getIterator() as $biosample) {
          if (!empty($biosample)) {
            $population_dto->addBioSamples($biosample->value());
          }
          if ($biosample->value() == 'others') {
            $population_dto->addOtherBioSamples($dto_util->_set_LocalizedStringDto($wrapper->field_dce_samples_man_other_sp->value->value()));
          }
          if ($biosample->value() == 'tissues') {
            $population_dto->addTissueTypes($dto_util->_set_LocalizedStringDto($wrapper->field_dce_tissues_sp->value()));
          }

        }
      }
      if ($sources->value() == 'administratives_databases') {
        foreach ($wrapper->field_dce_data_sources_admin_db->getIterator() as $admindata) {
          if (!empty($admindata)) {
            $population_dto->addAdministrativeDatabases($admindata->value());
          }
        }
      }
    }

  }
  //@TODO deal with attachement files
/////////////////////////////////////
  return $population_dto;
}