<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Post_Anesthesia_Orders_Monitoring.aspx.cs" Inherits="Design_OT_Post_Anesthesia_Orders_Monitoring" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Post Anesthesia</title>

    <style type="text/css">

        .selectedRow {
            background-color:antiquewhite;
        }
        .hidden {
            display:none
        }
    </style>


</head>
<body style="margin-right: 2px;">
    <form id="form1" runat="server">
        <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
        <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
        <cc1:ToolkitScriptManager runat="server" ID="scrmanager1"></cc1:ToolkitScriptManager>


        <script type="text/javascript">

            $(document).ready(function () {
                var transactionID = '<%=ViewState["TransactionID"].ToString()%>';

                getPostAnesthesiaMonitoring(transactionID, function () {
                    getPostAnesthesiaOrder(transactionID, function (data) {
                        bindPostAnesthesiaOrderDetails(data, function () {

                        });
                    });
                });
            });


            var getPostAnesthesiaOrder = function (transactionID, callback) {
                serverCall('Post_Anesthesia_Orders_Monitoring.aspx/GetPostAnesthesiaOrder', { transactionID: transactionID }, function (resposne) {
                    var responseData = JSON.parse(resposne);
                    if (responseData.length > 0)
                        callback(responseData[0]);

                });
            }




            var bindPostAnesthesiaOrderDetails = function (data, callback) {
                var divPostAnesthesiaOrders = $('.divPostAnesthesiaOrders');

                divPostAnesthesiaOrders.find('#txtNPOFor').val(data.NPOFor);
                divPostAnesthesiaOrders.find('#txtAnalgesics').val(data.Analgesics);
                divPostAnesthesiaOrders.find('#txtAntiemetics').val(data.Antiemetics);
                divPostAnesthesiaOrders.find('#txtIVFluids').val(data.IVFluids);
                divPostAnesthesiaOrders.find('#txtThromboprophalaxis').val(data.Thromboprophalaxis);
                divPostAnesthesiaOrders.find('#txtAntibiotics').val(data.Antibiotics);
                divPostAnesthesiaOrders.find('#txtOthers').val(data.Other);
                divPostAnesthesiaOrders.find('input[type=button]').val('Update');
                callback();
            }




            var getPostAnesthesiaMonitoring = function (transactionID, callback) {



                serverCall('Post_Anesthesia_Orders_Monitoring.aspx/GetPostAnesthesiaMonitoring', { transactionID: transactionID }, function (response) {
                    responseData = JSON.parse(response);
                    var parseHTML = $('#template_post_anesthesia_monitoring').parseTemplate(responseData);
                    $('.divProcedureMonitoringHistory').html(parseHTML);
                    callback();
                });
            }




            var getOrderData = function (callback) {

                var orderData = {
                    NPOFor: $.trim($('#txtNPOFor').val()),
                    Analgesics: $.trim($('#txtAnalgesics').val()),
                    Antiemetics: $.trim($('#txtAntiemetics').val()),
                    Ivfluids: $.trim($('#txtIVFluids').val()),
                    Thromboprophalaxis: $.trim($('#txtThromboprophalaxis').val()),
                    Antibiotics: $.trim($('#txtAntibiotics').val()),
                    Other: $.trim($('#txtOthers').val()),
                };


                var orderMonitoring = {
                    Id: Number($('#spanAnesthesiaMoniterID').text()),
                    Monitordate: $.trim($('#txtCurrentDate').val()),
                    Monitortime: $.trim($('#txtCurrentTime').val()),
                    Heartrate: $.trim($('#txtHeartRate').val()),
                    Bp: $.trim($('#txtBP').val()),
                    Spo2: $.trim($('#txtSPO2').val()),
                    Painscore: Number($('#txtPainScore').val()),
                    Sedation_score: $.trim($('#ddlSedationScore').val()),
                    SedationscoreText: $.trim($('#ddlSedationScore option:selected').text()),
                    SedationscoreValue: $.trim($('#ddlSedationScore').val()),
                    Bromage_score: $.trim($('#ddlBromageScore').val()),
                    BromagescoreText: $.trim($('#ddlBromageScore option:selected').text()),
                    BromagescoreValue: $.trim($('#ddlBromageScore').val()),
                    Aldretescore: Number($('#txtAldreteScore').val()),
                    ActivityText: $.trim($('#ddlActivity option:selected').text()),
                    ActivityValue: $.trim($('#ddlActivity').val()),
                    RespirationsText: $.trim($('#ddlRespirations option:selected').val()),
                    RespirationsValue: $.trim($('#ddlRespirations').val()),
                    CirculationText: $.trim($('#ddlCirculation option:selected').text()),
                    CirculationValue: $.trim($('#ddlCirculation').val()),
                    ConsciousText: $.trim($('#ddlConscious option:selected').text()),
                    ConsciousValue: $.trim($('#ddlConscious').val()),
                    O2saturationText: $.trim($('#ddlO2Saturation option:selected').text()),
                    O2saturationValue: $.trim($('#ddlO2Saturation').val()),
                    Coments: $.trim($('#txtComments').val()),
                    _Anesthesiologist: $.trim($('#ddlAnesthesiologist').val()),
                    Anesthesiologistid: $.trim($('#ddlAnesthesiologist').val()),
                    Shiftoutdate: $.trim($('#txtShiftOutDate').val()),
                    Shiftouttime: $.trim($('#txtShiftTimeOut').val())
                };


                callback({ _OtOrders: orderData, _OtMonitoring: orderMonitoring });

            }



            var onEditOtMonitoring = function (el) {
                var tdData = JSON.parse($(el).closest('tr').addClass('selectedRow').find('.tdData').text());
                
                var divPostAnesthesiaOrdersMonitoring = $('.divPostAnesthesiaOrdersMonitoring');
                divPostAnesthesiaOrdersMonitoring.find('#txtCurrentDate').val(tdData.MonitorDate);
                divPostAnesthesiaOrdersMonitoring.find('#txtCurrentTime').val(tdData.MonitorTime);
                divPostAnesthesiaOrdersMonitoring.find('#txtHeartRate').val(tdData.HeartRate);
                divPostAnesthesiaOrdersMonitoring.find('#txtBP').val(tdData.BP);
                divPostAnesthesiaOrdersMonitoring.find('#txtSPO2').val(tdData.SPO2);
                divPostAnesthesiaOrdersMonitoring.find('#txtPainScore').val(tdData.PainScore);
                divPostAnesthesiaOrdersMonitoring.find('#txtSedationScore').val(tdData.SedationScore);
                divPostAnesthesiaOrdersMonitoring.find('#ddlSedationScore').val(tdData.SedationScore_value);
                divPostAnesthesiaOrdersMonitoring.find('#txtBromageScore').val(tdData.BromageScore);
                divPostAnesthesiaOrdersMonitoring.find('#ddlBromageScore').val(tdData.BromageScore_Value);
                divPostAnesthesiaOrdersMonitoring.find('#txtAldreteScore').val(tdData.AldreteScore);
                divPostAnesthesiaOrdersMonitoring.find('#ddlActivity').val(tdData.Activity_value);
                divPostAnesthesiaOrdersMonitoring.find('#ddlRespirations').val(tdData.Respirations_value);
                divPostAnesthesiaOrdersMonitoring.find('#ddlCirculation').val(tdData.Circulation_value);
                divPostAnesthesiaOrdersMonitoring.find('#ddlConscious').val(tdData.Conscious_value);
                divPostAnesthesiaOrdersMonitoring.find('#ddlO2Saturation').val(tdData.O2Saturation_value);
                divPostAnesthesiaOrdersMonitoring.find('#txtComments').val(tdData.Coments);
                divPostAnesthesiaOrdersMonitoring.find('#ddlAnesthesiologist').val(tdData.Anesthesiologist);
                divPostAnesthesiaOrdersMonitoring.find('#txtShiftOutDate').val(tdData.ShiftOutDate);
                divPostAnesthesiaOrdersMonitoring.find('#txtShiftTimeOut').val(tdData.ShiftOutTime);
                divPostAnesthesiaOrdersMonitoring.find('#spanAnesthesiaMoniterID').text(tdData.ID);
                divPostAnesthesiaOrdersMonitoring.find('input[type=button]').val('Update');
            }


            var _saveMonitoring = function (savetype, btnSave) {
                saveMonitoring(savetype, function () {


                });
            }






            var saveMonitoring = function (saveType, btnSave) {
                getOrderData(function (data) {
                    var btnValue = btnSave.value;
                    $(btnSave).attr('disabled', true).val('Submitting...');
                    data.otBookingID = Number('<%=ViewState["OTBookingID"].ToString()%>');
                    data.transactionID = '<%=ViewState["TransactionID"].ToString()%>';
                    data.patientID = '<%=ViewState["PatientID"].ToString()%>';
                    data.savetype = saveType;
                    serverCall('Post_Anesthesia_Orders_Monitoring.aspx/Save', data, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.message, function () {
                            if (responseData.status)
                                window.location.reload()
                            else
                                $(btnSave).removeAttr('disabled').val(btnValue);
                        });
                    });
                });

            }



            var calculateBromageScore = function (el) {
                var bromageScore = Number(el.value);
                $('#txtBromageScore').val(bromageScore);
            }

            var calculateSedationScore = function (el) {
                var sedationScore = Number(el.value);
                $('#txtSedationScore').val(sedationScore);
            }


            var calculateAldreteScore = function (el) {

                var ddlActivity = Number($('#ddlActivity').val());
                var ddlRespirations = Number($('#ddlRespirations').val());
                var ddlCirculation = Number($('#ddlCirculation').val());
                var ddlConscious = Number($('#ddlConscious').val());
                var ddlO2Saturation = Number($('#ddlO2Saturation').val());

                var aldreteScore = (ddlActivity + ddlRespirations + ddlCirculation + ddlConscious + ddlConscious + ddlO2Saturation);
                $('#txtAldreteScore').val(aldreteScore);
            }

        </script>




        <div>
            <div id="Pbody_box_inventory">
                <div class="content" style="text-align: center;">
                    <b>Post Anesthesia Orders/Monitoring</b>
                </div>
                <div class="POuter_Box_Inventory divPostAnesthesiaOrders">
                    <div class="Purchaseheader">POST ANESTHESIA ORDERS</div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">NPO For</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtNPOFor" runat="server" onlynumber="5" decimalplace="2" max-value="100" CssClass="ItDoseTextinputNum"></asp:TextBox>

                        </div>
                        <div class="col-md-8" style="padding-top: 7px">
                            <b>HRS. OR As Per Surgons Order.</b>
                        </div>

                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Analgesics</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <textarea cols="" rows="" id="txtAnalgesics"></textarea>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Antiemetics</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <textarea cols="" rows="" id="txtAntiemetics">

                            </textarea>
                        </div>
                    </div>

                    <div class="row">

                        <div class="col-md-4">
                            <label class="pull-left">IV Fluids</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <textarea cols="" rows="" id="txtIVFluids"></textarea>
                        </div>


                        <div class="col-md-4">
                            <label class="pull-left">Thromboprophalaxis</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <textarea cols="" rows="" id="txtThromboprophalaxis"></textarea>
                        </div>


                    </div>


                    <div class="row">


                        <div class="col-md-4">
                            <label class="pull-left">Antibiotics</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <textarea cols="" rows="" id="txtAntibiotics"></textarea>
                        </div>


                        <div class="col-md-4">
                            <label class="pull-left">Other</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <textarea cols="" rows="" id="txtOthers"></textarea>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left" style="color: red">
                                <b>Remarks</b>
                            </label>
                            <b class="pull-right" style="color: red">:</b>
                        </div>

                        <div class="col-md-20 patientInfo">
                            1. Oxygen to keep SPO2 Greater than 92%(Mask or Nasal Cannula)
                            <br />
                            2. MONITOR PATIENT FOR PULSE,NIBP,SPO2,TEMP,URINE OUTPUT,DRAINS,PAIN,SENSORY LEVEL,SEDIDATION SCORE FOR EVERY 5 MINS THEN EVERY 15 MINS FOR 1 HR.
                        </div>


                    </div>

                </div>


                <div class="POuter_Box_Inventory divPostAnesthesiaOrders textCenter">
                    <input type="button" value="Save" class="save margin-top-on-btn" onclick="_saveMonitoring(1, this)" />
                </div>

                <div class="POuter_Box_Inventory divPostAnesthesiaOrdersMonitoring">
                    <div class="Purchaseheader">POST ANESTHESIA/PROCEDURE MONITORING</div>
                    <span id="spanAnesthesiaMoniterID" class="hidden">0</span>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Date/Time</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox runat="server" ID="txtCurrentDate"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtCurrentDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox runat="server" ID="txtCurrentTime"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time" TargetControlID="txtCurrentTime" AcceptAMPM="True"></cc1:MaskedEditExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Heart Rate/B.P.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <input type="text" id="txtHeartRate" />
                        </div>
                        <div class="col-md-2">
                            <b>HR/Min </b>
                        </div>
                        <div class="col-md-2">
                            
                            <input type="text" id="txtBP" />  
                        </div>
                        <div class="col-md-2">
                            <b>mm/hg </b>
                        </div>

                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">SPO2/PAIN SCORE</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            
                            <input type="text"  id="txtSPO2"/>
                        </div>
                        <div class="col-md-2">
                            <b>O2l/m </b>
                        </div>
                        <div class="col-md-4">
                           <input type="text"   id="txtPainScore" onlynumber="2"  max-value="10"    style="font-weight:bold;color: #0000FF;" class="ItDoseTextinputNum"/>
                        </div>

                        <div class="col-md-4">
                            <label class="pull-left">SEDATION SCORE</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <input type="text" id="txtSedationScore" value="1" disabled="disabled" style="font-weight:bold;color: #0000FF;" class="ItDoseTextinputNum" />
                        </div>
                        <div class="col-md-6">
                            <select id="ddlSedationScore" onchange="calculateSedationScore(this)">
                                <option value="1">Anxious and agitated or restless,or both</option>
                                <option value="2">Cooperative,oriented and tranquil</option>
                                <option value="3">Patient responds to commonds only</option>
                                <option value="4">Brisk response to light glabellar tap/voice</option>
                                <option value="5">Sluggish response to light glabellar tap </option>
                                <option value="6">Patient exhibits no response </option>
                            </select>
                        </div>


                    </div>


                    <div class="row">
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">M. Bromage Score</label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-2">
                            <input type="text" id="txtBromageScore" value="1" disabled="disabled" style="font-weight:bold;color: #0000FF;" class="ItDoseTextinputNum" />
                        </div>
                        <div class="col-md-6">
                            <select id="ddlBromageScore" onchange="calculateBromageScore(this)">

                                <option value="1">Complete block(unable to move feet or knees)</option>
                                <option value="2">Almost Complete block(able to move feet or knees)</option>
                                <option value="3">Partial block(Just able to move knees)</option>
                                <option value="4">Detectable weakness of hip flexion while supine (full flexion of knees)</option>
                                <option value="5">No detectable weakness of hip flexion while supine </option>
                                <option value="6">Able to perform partial knee bend </option>

                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="pull-left">Aldrete Score</label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-2">
                            <input type="text" id="txtAldreteScore" value="0" disabled="disabled" style="font-weight:bold;color: #0000FF;" class="patientInfo" />
                        </div>
                        <div class="col-md-6">
                        </div>



                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Activity</label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-8">
                            <select id="ddlActivity" onchange="calculateAldreteScore(this)">

                                <option value="0">Moves 0 limbs</option>
                                <option value="1">Moves 2 limbs</option>
                                <option value="2">Moves 4 limbs</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Respirations</label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-8">
                            <select id="ddlRespirations" onchange="calculateAldreteScore(this)">
                                <option value="0">Apneic or mechanical vent </option>
                                <option value="1">Dyspnea cc tachapnces</option>
                                <option value="2">Able to cough, deep breath</option>
                            </select>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Circulation</label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-8">
                            <select id="ddlCirculation" onchange="calculateAldreteScore(this)">
                                <option value="0">BP+/- 50% of pre -op level</option>
                                <option value="1">al,+/- 20 to 49% of preop</option>
                                <option value="2">BP+/- 20% of pre -op level</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Conscious</label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-8">
                            <select id="ddlConscious" onchange="calculateAldreteScore(this)">
                                <option value="0">Not responsive</option>
                                <option value="1">Arousable tovoice</option>
                                <option value="2">Fullyawake</option>
                            </select>
                        </div>
                    </div>

                    <div class="row">

                        <div class="col-md-4">
                            <label class="pull-left">O2 Saturation</label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-8">
                            <select id="ddlO2Saturation" onchange="calculateAldreteScore(this)">
                                <option value="0">Sp02 < 92% with supplemental 02</option>
                                <option value="1">Sp02 , 9296 with oxygen</option>
                                <option value="2">Sp02 92% morn air</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="pull-left">Coments</label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-8">
                            <input type="text" id="txtComments" />
                        </div>


                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Anesthesiologist</label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-8">
                            <input type="text" id="ddlAnesthesiologist" />
                        </div>

                        <div class="col-md-4">
                            <label class="pull-left">Shift Time Out</label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <asp:TextBox runat="server" ID="txtShiftOutDate"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID="txtShiftOutDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox runat="server" ID="txtShiftTimeOut"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" Mask="99:99" runat="server" MaskType="Time" TargetControlID="txtShiftTimeOut" AcceptAMPM="True"></cc1:MaskedEditExtender>

                        </div>
                    </div>

                    

                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left" style="color: red">
                                <b>Discharge Criteria</b>
                            </label>
                            <b class="pull-right" style="color: red">:</b>
                        </div>

                        <div class="col-md-20 patientInfo">
                            1. Aldrete score 8 or above.<br />
                            2. M. Bromage Score 4 or above.
                        </div>


                    </div>

                </div>

                <div class="POuter_Box_Inventory  divPostAnesthesiaOrdersMonitoring textCenter">
                    <input type="button" value="Save" class="save margin-top-on-btn" onclick="_saveMonitoring(2, this)" />
                </div>
                <div class="POuter_Box_Inventory textCenter">
                    <div class="Purchaseheader">PROCEDURE MONITORING HISTORY</div>

                    <div class="row divProcedureMonitoringHistory"></div>

                </div>
            </div>
        </div>



            <script id="template_post_anesthesia_monitoring" type="text/html">
        <table  id="tbl_post_anesthesia_monitoring" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
        <thead>
        <tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col">#</th>
            <th class="GridViewHeaderStyle" scope="col">Date/Time</th>
            <th class="GridViewHeaderStyle" scope="col" >Heart Rate</th>
            <th class="GridViewHeaderStyle" scope="col" >B.P</th>
            <th class="GridViewHeaderStyle" scope="col" >SPO2</th>
            <th class="GridViewHeaderStyle" scope="col" >PAIN SCORE</th>
            <th class="GridViewHeaderStyle" scope="col" >Bromage Score</th>  
            <th class="GridViewHeaderStyle" scope="col">SEDATION SCORE</th>  
            <th class="GridViewHeaderStyle" scope="col">Aldrete Score</th>  
            <th class="GridViewHeaderStyle" scope="col">Anesthesiologist</th>  
            <th class="GridViewHeaderStyle" scope="col">Shift TimeOut</th>
            <th class="GridViewHeaderStyle" scope="col">Comments</th>    
            <th class="GridViewHeaderStyle" scope="col">Edit</th> 

                                 
        </tr>
            </thead>   
            <tbody>

                <#
                     var dataLength=responseData.length;        
                     var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = responseData[j];
                #>          
                

                        <tr style='cursor:pointer;'>                              
                        <td  class="GridViewLabItemStyle"><#=j+1#></td>                                   
                        <td  class="GridViewLabItemStyle"><#=objRow.MonitorDate#> <#=objRow.MonitorTime#> </td>
                        <td class="GridViewLabItemStyle"><#=objRow.HeartRate#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.BP#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.SPO2#></td> 
                        <td class="GridViewLabItemStyle"><#=objRow.PainScore#></td>   
                        <td class="GridViewLabItemStyle"><#=objRow.BromageScore#></td>       
                        <td class="GridViewLabItemStyle"><#=objRow.SedationScore#></td> 
                        <td class="GridViewLabItemStyle"><#=objRow.AldreteScore#></td> 
                        <td class="GridViewLabItemStyle"><#=objRow.Anesthesiologist#></td> 
                        <td class="GridViewLabItemStyle"><#=objRow.ShiftOutDate#> <#=objRow.ShiftOutTime#></td> 
                        <td class="GridViewLabItemStyle"><#=objRow.Coments#></td> 
                        
                         <td class="GridViewLabItemStyle tdData"  style="display:none"><#=JSON.stringify(objRow)#></td>  
                        <td class="GridViewLabItemStyle">  
                            <img src="../../Images/Post.gif" alt="" title="Select To Edit" onclick="onEditOtMonitoring(this)" />
                        </td>                       
                        </tr>            

            <#}#>            
            </tbody>
         </table>    
    </script>


    </form>
</body>
</html>
