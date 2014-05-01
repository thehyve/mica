<?php

include_once('protobuf/Protobuf.php');
use \DrSlump\Protobuf;

Protobuf::autoload();

const HEADER_BINARY = 'application/x-protobuf';
const HEADER_JSON = 'application/json';

include_once('protobuf/protos/Mica.php');

class QuerySendDto {

  function _set_LocalizedStringDto($value) {
    global $language;
    $lang = $language->language;
    $locate = new \obiba\mica\LocalizedStringDto();
    $locate->setLang($lang);
    $locate->setValue($value);
    return $locate;
  }

// function _set_LocalizedStringDto($value){
//   global $language;
//   if(module_exists('locale')){
//   $langs =  locale_language_list();
//   }
//   else{
//     if (empty($lang)) {
//       $langs[$language->language]=$language->language;
//     }
//   }
//   foreach($langs as $lang=>$ln){
//   $locate = new \obiba\mica\LocalizedStringDto();
//   $locate->setLang($lang);
//   $locate->setValue(drupal_html_to_text($value));
//   }
//return $locate;
// }

}