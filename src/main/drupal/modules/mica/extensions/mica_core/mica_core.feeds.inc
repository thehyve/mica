<?php
/**
 * @file
 * Mica mapper for mica fields.
 */

/**
 * Implements hook_feeds_processor_targets_alter().
 *
 * @see FeedsNodeProcessor::getMappingTargets().
 */
function mica_core_feeds_processor_targets_alter(&$targets, $entity_type, $bundle_name) {
  foreach (field_info_instances($entity_type, $bundle_name) as $name => $instance) {
    if ($name === 'body') {
      $targets[$name] = array(
        'name' => $name,
        'callback' => 'mica_core_feeds_set_target_body',
        'description' => t('The @label field of the node.', array('@label' => $instance['label'])),
      );
    }
    elseif ($name === 'title') {
      $targets[$name] = array(
        'name' => $name,
        'callback' => 'mica_core_feeds_set_target_title',
        'description' => t('The @label field of the node.', array('@label' => $instance['label'])),
      );
    }
    elseif ($name === 'field_study_legacy_id') {
      $targets['field_study_legacy_id'] = array(
        'name' => $instance['label'],
        'callback' => 'mica_core_feeds_set_target_legacy_id',
        'description' => t('The Legacy Id of the parent Study of the node.', array('@label' => $instance['label'])),
      );
    }
  }
}

function mica_core_feeds_set_target_title($source, $entity, $target, $value) {
  _mica_core_set_target($source, $entity, $target, $value);
}

function mica_core_feeds_set_target_body($source, $entity, $target, $value) {
  _mica_core_set_target($source, $entity, $target, $value);
}

function mica_core_feeds_set_target_legacy_id($source, $entity, $target, $value) {
  _mica_core_set_target($source, $entity, $target, $value);
}

/**
 * Callback for mapping. Here is where the actual mapping happens.
 *
 * When the callback is invoked, $target contains the name of the field the
 * user has decided to map to and $value contains the value of the feed item
 * element the user has picked as a source.
 */
function _mica_core_set_target($source, $entity, $target, $value, $value_field = 'value') {
  if (empty($value)) {
    return;
  }

  // Handle non-multiple value fields.
  if (!is_array($value)) {
    $value = array($value);
  }

  // Iterate over all values.
  $i = 0;
  $info = field_info_field($target);
  $field_name = $target;
  if (strpos($target, ':') !== FALSE) {
    list($field_name, $sub_field) = explode(':', $target);
  }
  foreach ($value as $v) {
    $new_value = $v;
    if (!is_array($new_value) && !is_object($new_value)) {
      if (isset($sub_field)) {
        $field[LANGUAGE_NONE][$i][$sub_field] = $new_value;
      }
      else {
        $field[LANGUAGE_NONE][$i][$value_field] = $new_value;
      }
    }
    if ($info['cardinality'] == 1) {
      break;
    }
    $i++;
  }

  if (isset($sub_field)) {
    foreach ($field[LANGUAGE_NONE] as $i => $sub) {
      $entity->{$field_name}[LANGUAGE_NONE][$i][$sub_field] = $field[LANGUAGE_NONE][$i][$sub_field];
    }
  }
  else {
    $entity->{$field_name} = $field;
  }
}