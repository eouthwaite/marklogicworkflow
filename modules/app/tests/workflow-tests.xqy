xquery version "1.0-ml";

declare module namespace m="http://marklogic.com/workflow-tests" at "/app/tests/workflow-tests.xqy";

import module namespace wfi="http://marklogic.com/workflow-import" at "/app/models/workflow-import.xqy";

(: XDMP AS USER CALLS :)

declare function m:asDesigner($function as function() as item()*) {
  xdmp:invoke-function($function,
    <options xmlns="xdmp:eval">
      <database>{xdmp:database()}</database>
      <transaction-mode>update-auto-commit</transaction-mode>
      <isolation>same-transaction</isolation>
      <user>workflow-designer-user</user> (: TODO VALIDATE :)
    </options>
  )
};

declare function m:asManager($function as function() as item()*) {
  xdmp:invoke-function($function,
    <options xmlns="xdmp:eval">
      <database>{xdmp:database()}</database>
      <transaction-mode>update-auto-commit</transaction-mode>
      <isolation>same-transaction</isolation>
      <user>workflow-manager-user</user> (: TODO VALIDATE :)
    </options>
  )
};

declare function m:asUser($function as function() as item()*) {
  xdmp:invoke-function($function,
    <options xmlns="xdmp:eval">
      <database>{xdmp:database()}</database>
      <transaction-mode>update-auto-commit</transaction-mode>
      <isolation>same-transaction</isolation>
      <user>workflow-user</user> (: TODO VALIDATE :)
    </options>
  )
};

(: MARKLOGIC WORKFLOW SHELL SCRIPT EQUIVALENTS (for testing in QConsole) :)

declare function m:processmodel-create01() {
  m:asDesigner(function() {
  wfi:install-and-convert(
    <bpmn2:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn2="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:ns="http://www.w3.org/2001/XMLSchema" xmlns:ns1="http://marklogic.com/workflow" xmlns:ns2.xsd="http://marklogic.com/workflow" id="Definitions_1" exporter="org.eclipse.bpmn2.modeler.core" exporterVersion="1.1.3.201504140132" name="MarkLogicWorkflow" targetNamespace="http://marklogic.com/workflow">
      <bpmn2:import importType="http://www.w3.org/2001/XMLSchema" location="platform:/resource/MarkLogic%20Workflow/documentation/marklogicworkflow.xsd" namespace="http://marklogic.com/workflow"/>
      <bpmn2:itemDefinition id="ItemDefinition_5" isCollection="false" structureRef="process"/>
      <bpmn2:itemDefinition id="ItemDefinition_1" isCollection="false" structureRef="ns2.xsd:process"/>
      <bpmn2:resource id="Resource_1" name="admin"/>
      <bpmn2:resource id="Resource_2" name="Editors"/>
      <bpmn2:resource id="Resource_3" name="DynamicUser"/>
      <bpmn2:process id="restapitests" name="REST API Test 015" isExecutable="false" processType="Public">
        <bpmn2:userTask id="UserTask_2" name="Editor Queue Approval">
          <bpmn2:documentation id="Documentation_20">Assigned to a work stack</bpmn2:documentation>
          <bpmn2:incoming>SequenceFlow_3</bpmn2:incoming>
          <bpmn2:outgoing>SequenceFlow_4</bpmn2:outgoing>
          <bpmn2:resourceRole id="ResourceRole_2" name="Queue">
            <bpmn2:resourceRef>Resource_2</bpmn2:resourceRef>
          </bpmn2:resourceRole>
        </bpmn2:userTask>
        <bpmn2:sequenceFlow id="SequenceFlow_4" name="Complete" sourceRef="UserTask_2" targetRef="UserTask_4"/>
        <bpmn2:startEvent id="StartEvent_1" name="Start">
          <bpmn2:outgoing>SequenceFlow_2</bpmn2:outgoing>
        </bpmn2:startEvent>
        <bpmn2:sequenceFlow id="SequenceFlow_2" sourceRef="StartEvent_1" targetRef="UserTask_1"/>
        <bpmn2:userTask id="UserTask_1" name="User Decides Something">
          <bpmn2:documentation id="Documentation_19">Named user task</bpmn2:documentation>
          <bpmn2:incoming>SequenceFlow_2</bpmn2:incoming>
          <bpmn2:outgoing>SequenceFlow_3</bpmn2:outgoing>
          <bpmn2:resourceRole id="ResourceRole_1" name="Assignee">
            <bpmn2:resourceRef>Resource_1</bpmn2:resourceRef>
          </bpmn2:resourceRole>
        </bpmn2:userTask>
        <bpmn2:sequenceFlow id="SequenceFlow_3" name="Complete" sourceRef="UserTask_1" targetRef="UserTask_2"/>
        <bpmn2:exclusiveGateway id="ExclusiveGateway_1" name="Check Has Attachment" gatewayDirection="Diverging" default="SequenceFlow_6">
          <bpmn2:incoming>SequenceFlow_12</bpmn2:incoming>
          <bpmn2:outgoing>SequenceFlow_1</bpmn2:outgoing>
          <bpmn2:outgoing>SequenceFlow_6</bpmn2:outgoing>
        </bpmn2:exclusiveGateway>
        <bpmn2:sequenceFlow id="SequenceFlow_1" name="Has Attachment" sourceRef="ExclusiveGateway_1" targetRef="Task_1">
          <bpmn2:conditionExpression xsi:type="bpmn2:tFormalExpression" id="FormalExpression_1" language="http://www.w3.org/1999/XPath">fn:not(fn:empty($wf:process/wf:attachments/wf:attachment[@name=&quot;Document&quot;]/@uri))</bpmn2:conditionExpression>
        </bpmn2:sequenceFlow>
        <bpmn2:sequenceFlow id="SequenceFlow_6" name="No Attachment" sourceRef="ExclusiveGateway_1" targetRef="ExclusiveGateway_3"/>
        <bpmn2:task id="Task_1" name="Do Something With Attachment">
          <bpmn2:incoming>SequenceFlow_1</bpmn2:incoming>
          <bpmn2:outgoing>SequenceFlow_5</bpmn2:outgoing>
        </bpmn2:task>
        <bpmn2:sequenceFlow id="SequenceFlow_5" name="Complete" sourceRef="Task_1" targetRef="ExclusiveGateway_2"/>
        <bpmn2:exclusiveGateway id="ExclusiveGateway_2" name="Check Document Property" gatewayDirection="Diverging" default="SequenceFlow_7">
          <bpmn2:incoming>SequenceFlow_5</bpmn2:incoming>
          <bpmn2:outgoing>SequenceFlow_7</bpmn2:outgoing>
          <bpmn2:outgoing>SequenceFlow_8</bpmn2:outgoing>
        </bpmn2:exclusiveGateway>
        <bpmn2:sequenceFlow id="SequenceFlow_7" name="Property doesn't match" sourceRef="ExclusiveGateway_2" targetRef="ExclusiveGateway_3"/>
        <bpmn2:sequenceFlow id="SequenceFlow_8" name="Property Matches" sourceRef="ExclusiveGateway_2" targetRef="Task_2">
          <bpmn2:conditionExpression xsi:type="bpmn2:tFormalExpression" id="FormalExpression_2" language="http://www.w3.org/1999/XPath">fn:doc(xs:string($wf:process/wf:attachments/wf:attachment[@name=&quot;Document&quot;]/@uri))/mydoc/choiceA = &quot;wibble&quot;</bpmn2:conditionExpression>
        </bpmn2:sequenceFlow>
        <bpmn2:task id="Task_2" name="Do something with value">
          <bpmn2:incoming>SequenceFlow_8</bpmn2:incoming>
          <bpmn2:outgoing>SequenceFlow_9</bpmn2:outgoing>
        </bpmn2:task>
        <bpmn2:sequenceFlow id="SequenceFlow_9" name="Complete" sourceRef="Task_2" targetRef="ExclusiveGateway_3"/>
        <bpmn2:exclusiveGateway id="ExclusiveGateway_3" name="Should we party like it's 1999 (before millennium)?" gatewayDirection="Diverging" default="SequenceFlow_11">
          <bpmn2:incoming>SequenceFlow_6</bpmn2:incoming>
          <bpmn2:incoming>SequenceFlow_7</bpmn2:incoming>
          <bpmn2:incoming>SequenceFlow_9</bpmn2:incoming>
          <bpmn2:outgoing>SequenceFlow_10</bpmn2:outgoing>
          <bpmn2:outgoing>SequenceFlow_11</bpmn2:outgoing>
        </bpmn2:exclusiveGateway>
        <bpmn2:sequenceFlow id="SequenceFlow_10" name="Before Millennium" sourceRef="ExclusiveGateway_3" targetRef="EndEvent_1">
          <bpmn2:conditionExpression xsi:type="bpmn2:tFormalExpression" id="FormalExpression_3" language="http://www.w3.org/1999/XPath">fn:current-dateTime() lt xs:dateTime(&quot;2000-01-01T00:00:00&quot;)</bpmn2:conditionExpression>
        </bpmn2:sequenceFlow>
        <bpmn2:sequenceFlow id="SequenceFlow_11" name="Later than 1999" sourceRef="ExclusiveGateway_3" targetRef="EndEvent_2"/>
        <bpmn2:endEvent id="EndEvent_1" name="End Happy">
          <bpmn2:incoming>SequenceFlow_10</bpmn2:incoming>
        </bpmn2:endEvent>
        <bpmn2:endEvent id="EndEvent_2" name="End Sad">
          <bpmn2:incoming>SequenceFlow_11</bpmn2:incoming>
        </bpmn2:endEvent>
        <bpmn2:userTask id="UserTask_4" name="Dynamic User Decides Something">
          <bpmn2:documentation id="Documentation_4">Named user task assigned dynamically</bpmn2:documentation>
          <bpmn2:incoming>SequenceFlow_4</bpmn2:incoming>
          <bpmn2:outgoing>SequenceFlow_12</bpmn2:outgoing>
          <bpmn2:humanPerformer id="HumanPerformer_1" name="DynamicPerformer">
            <bpmn2:resourceRef>Resource_3</bpmn2:resourceRef>
            <bpmn2:resourceAssignmentExpression id="ResourceAssignmentExpression_1">
              <bpmn2:formalExpression id="FormalExpression_4" language="http://www.w3.org/1999/XPath">$wf:process/wf:data/newassignee/text()</bpmn2:formalExpression>
            </bpmn2:resourceAssignmentExpression>
          </bpmn2:humanPerformer>
        </bpmn2:userTask>
        <bpmn2:sequenceFlow id="SequenceFlow_12" sourceRef="UserTask_4" targetRef="ExclusiveGateway_1"/>
        <bpmn2:property id="Property_1" itemSubjectRef="ItemDefinition_5" name="processData"/>
      </bpmn2:process>
      <bpmndi:BPMNDiagram id="BPMNDiagram_1" name="REST API Test 015">
        <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="restapitests">
          <bpmndi:BPMNShape id="BPMNShape_1" bpmnElement="StartEvent_1">
            <dc:Bounds height="36.0" width="36.0" x="30.0" y="143.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_1" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="20.0" x="38.0" y="179.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNShape>
          <bpmndi:BPMNShape id="BPMNShape_2" bpmnElement="EndEvent_1">
            <dc:Bounds height="36.0" width="36.0" x="150.0" y="261.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_2" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="45.0" x="146.0" y="297.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNShape>
          <bpmndi:BPMNShape id="BPMNShape_UserTask_2" bpmnElement="UserTask_2">
            <dc:Bounds height="50.0" width="161.0" x="510.0" y="136.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_3" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="93.0" x="544.0" y="156.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNShape>
          <bpmndi:BPMNShape id="BPMNShape_UserTask_1" bpmnElement="UserTask_1">
            <dc:Bounds height="50.0" width="161.0" x="200.0" y="136.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_4" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="101.0" x="230.0" y="156.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNShape>
          <bpmndi:BPMNShape id="BPMNShape_ExclusiveGateway_1" bpmnElement="ExclusiveGateway_1" isMarkerVisible="true">
            <dc:Bounds height="50.0" width="50.0" x="565.0" y="254.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_5" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="20.0" width="54.0" x="563.0" y="304.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNShape>
          <bpmndi:BPMNShape id="BPMNShape_Task_1" bpmnElement="Task_1">
            <dc:Bounds height="50.0" width="110.0" x="730.0" y="254.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_6" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="20.0" width="90.0" x="740.0" y="269.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNShape>
          <bpmndi:BPMNShape id="BPMNShape_ExclusiveGateway_2" bpmnElement="ExclusiveGateway_2" isMarkerVisible="true">
            <dc:Bounds height="50.0" width="50.0" x="760.0" y="367.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_7" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="20.0" width="79.0" x="746.0" y="417.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNShape>
          <bpmndi:BPMNShape id="BPMNShape_Task_2" bpmnElement="Task_2">
            <dc:Bounds height="50.0" width="110.0" x="730.0" y="476.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_8" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="100.0" x="735.0" y="496.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNShape>
          <bpmndi:BPMNShape id="BPMNShape_ExclusiveGateway_3" bpmnElement="ExclusiveGateway_3" isMarkerVisible="true">
            <dc:Bounds height="50.0" width="50.0" x="390.0" y="367.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_9" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="30.0" width="78.0" x="376.0" y="417.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNShape>
          <bpmndi:BPMNShape id="BPMNShape_EndEvent_1" bpmnElement="EndEvent_2">
            <dc:Bounds height="36.0" width="36.0" x="150.0" y="483.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_10" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="35.0" x="150.0" y="519.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNShape>
          <bpmndi:BPMNShape id="BPMNShape_UserTask_3" bpmnElement="UserTask_4">
            <dc:Bounds height="50.0" width="161.0" x="760.0" y="136.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_22" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="139.0" x="771.0" y="156.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNShape>
          <bpmndi:BPMNEdge id="BPMNEdge_SequenceFlow_2" bpmnElement="SequenceFlow_2" sourceElement="BPMNShape_1" targetElement="BPMNShape_UserTask_1">
            <di:waypoint xsi:type="dc:Point" x="66.0" y="161.0"/>
            <di:waypoint xsi:type="dc:Point" x="133.0" y="161.0"/>
            <di:waypoint xsi:type="dc:Point" x="200.0" y="161.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_11" labelStyle="BPMNLabelStyle_1"/>
          </bpmndi:BPMNEdge>
          <bpmndi:BPMNEdge id="BPMNEdge_SequenceFlow_3" bpmnElement="SequenceFlow_3" sourceElement="BPMNShape_UserTask_1" targetElement="BPMNShape_UserTask_2">
            <di:waypoint xsi:type="dc:Point" x="361.0" y="161.0"/>
            <di:waypoint xsi:type="dc:Point" x="435.0" y="161.0"/>
            <di:waypoint xsi:type="dc:Point" x="510.0" y="161.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_12" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="38.0" x="418.0" y="162.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNEdge>
          <bpmndi:BPMNEdge id="BPMNEdge_SequenceFlow_4" bpmnElement="SequenceFlow_4" sourceElement="BPMNShape_UserTask_2" targetElement="BPMNShape_UserTask_3">
            <di:waypoint xsi:type="dc:Point" x="671.0" y="161.0"/>
            <di:waypoint xsi:type="dc:Point" x="715.0" y="161.0"/>
            <di:waypoint xsi:type="dc:Point" x="760.0" y="161.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_13" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="38.0" x="698.0" y="162.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNEdge>
          <bpmndi:BPMNEdge id="BPMNEdge_SequenceFlow_1" bpmnElement="SequenceFlow_1" sourceElement="BPMNShape_ExclusiveGateway_1" targetElement="BPMNShape_Task_1">
            <di:waypoint xsi:type="dc:Point" x="615.0" y="279.0"/>
            <di:waypoint xsi:type="dc:Point" x="672.0" y="279.0"/>
            <di:waypoint xsi:type="dc:Point" x="730.0" y="279.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_14" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="66.0" x="641.0" y="280.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNEdge>
          <bpmndi:BPMNEdge id="BPMNEdge_SequenceFlow_5" bpmnElement="SequenceFlow_5" sourceElement="BPMNShape_Task_1" targetElement="BPMNShape_ExclusiveGateway_2">
            <di:waypoint xsi:type="dc:Point" x="785.0" y="304.0"/>
            <di:waypoint xsi:type="dc:Point" x="785.0" y="335.0"/>
            <di:waypoint xsi:type="dc:Point" x="785.0" y="367.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_15" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="38.0" x="767.0" y="337.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNEdge>
          <bpmndi:BPMNEdge id="BPMNEdge_SequenceFlow_6" bpmnElement="SequenceFlow_6" sourceElement="BPMNShape_ExclusiveGateway_1" targetElement="BPMNShape_ExclusiveGateway_3">
            <di:waypoint xsi:type="dc:Point" x="565.0" y="279.0"/>
            <di:waypoint xsi:type="dc:Point" x="415.0" y="279.0"/>
            <di:waypoint xsi:type="dc:Point" x="415.0" y="367.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_16" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="61.0" x="416.0" y="280.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNEdge>
          <bpmndi:BPMNEdge id="BPMNEdge_SequenceFlow_7" bpmnElement="SequenceFlow_7" sourceElement="BPMNShape_ExclusiveGateway_2" targetElement="BPMNShape_ExclusiveGateway_3">
            <di:waypoint xsi:type="dc:Point" x="760.0" y="392.0"/>
            <di:waypoint xsi:type="dc:Point" x="600.0" y="392.0"/>
            <di:waypoint xsi:type="dc:Point" x="440.0" y="392.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_17" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="20.0" width="75.0" x="563.0" y="393.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNEdge>
          <bpmndi:BPMNEdge id="BPMNEdge_SequenceFlow_8" bpmnElement="SequenceFlow_8" sourceElement="BPMNShape_ExclusiveGateway_2" targetElement="BPMNShape_Task_2">
            <di:waypoint xsi:type="dc:Point" x="785.0" y="417.0"/>
            <di:waypoint xsi:type="dc:Point" x="785.0" y="446.0"/>
            <di:waypoint xsi:type="dc:Point" x="785.0" y="476.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_18" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="73.0" x="749.0" y="448.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNEdge>
          <bpmndi:BPMNEdge id="BPMNEdge_SequenceFlow_9" bpmnElement="SequenceFlow_9" sourceElement="BPMNShape_Task_2" targetElement="BPMNShape_ExclusiveGateway_3">
            <di:waypoint xsi:type="dc:Point" x="730.0" y="501.0"/>
            <di:waypoint xsi:type="dc:Point" x="415.0" y="501.0"/>
            <di:waypoint xsi:type="dc:Point" x="415.0" y="418.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_19" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="38.0" x="513.0" y="502.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNEdge>
          <bpmndi:BPMNEdge id="BPMNEdge_SequenceFlow_10" bpmnElement="SequenceFlow_10" sourceElement="BPMNShape_ExclusiveGateway_3" targetElement="BPMNShape_2">
            <di:waypoint xsi:type="dc:Point" x="390.0" y="392.0"/>
            <di:waypoint xsi:type="dc:Point" x="168.0" y="392.0"/>
            <di:waypoint xsi:type="dc:Point" x="168.0" y="297.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_20" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="72.0" x="197.0" y="393.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNEdge>
          <bpmndi:BPMNEdge id="BPMNEdge_SequenceFlow_11" bpmnElement="SequenceFlow_11" sourceElement="BPMNShape_ExclusiveGateway_3" targetElement="BPMNShape_EndEvent_1">
            <di:waypoint xsi:type="dc:Point" x="390.0" y="392.0"/>
            <di:waypoint xsi:type="dc:Point" x="168.0" y="392.0"/>
            <di:waypoint xsi:type="dc:Point" x="168.0" y="483.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_21" labelStyle="BPMNLabelStyle_1">
              <dc:Bounds height="10.0" width="65.0" x="202.0" y="393.0"/>
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNEdge>
          <bpmndi:BPMNEdge id="BPMNEdge_SequenceFlow_12" bpmnElement="SequenceFlow_12" sourceElement="BPMNShape_UserTask_3" targetElement="BPMNShape_ExclusiveGateway_1">
            <di:waypoint xsi:type="dc:Point" x="840.0" y="186.0"/>
            <di:waypoint xsi:type="dc:Point" x="840.0" y="220.0"/>
            <di:waypoint xsi:type="dc:Point" x="590.0" y="220.0"/>
            <di:waypoint xsi:type="dc:Point" x="590.0" y="254.0"/>
            <bpmndi:BPMNLabel id="BPMNLabel_23" labelStyle="BPMNLabelStyle_1"/>
          </bpmndi:BPMNEdge>
        </bpmndi:BPMNPlane>
        <bpmndi:BPMNLabelStyle id="BPMNLabelStyle_1">
          <dc:Font name="arial" size="9.0"/>
        </bpmndi:BPMNLabelStyle>
      </bpmndi:BPMNDiagram>
    </bpmn2:definitions>
    , "015-restapi-tests.bpmn",1,0,fn:false()
    )
  })
};

declare function m:processmodel-update03() {
  m:asDesigner(function() {
  })
};

declare function m:processmodel-publish04() {
  m:asManager(function() {
  })
};

declare function m:process-create06() {
  m:asUser(function() {
  })
};

declare function m:processinbox-read08() {
  m:asUser(function() {
  })
};
