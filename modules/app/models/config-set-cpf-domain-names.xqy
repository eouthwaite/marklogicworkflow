xquery version "1.0-ml";

declare namespace my="http://marklogic.com/alerts";

import module namespace la = "http://marklogic.com/alerts/alerting" at "/app/models/lib-alerting.xqy";
import module namespace alert="http://marklogic.com/xdmp/alert" at "/MarkLogic/alert.xqy";

declare variable $my:alert-name as xs:string external;

alert:config-set-cpf-domain-names(alert:config-get($my:alert-name), ())