<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BloodTransfusionRecords.aspx.cs" Inherits="Design_IPD_BloodTransfusionRecords" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>

    <style type="text/css">
        .auto-style1 {
            width: 458px;
        }

        .auto-style2 {
            width: 15%;
        }
    </style>

</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <script src="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.js"></script>
    <link href="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.css" rel="stylesheet" />

    <form id="form1" runat="server">

        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>BLOOD TRANSFUSION RECORDS</b>
                <br />

                <span id="spnErrorMsg" class="ItDoseLblError"></span>
                <span id="spnTransactionID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnPatientID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnRecordId" runat="server" clientidmode="Static" style="display: none">0</span>

            </div>


            <div class="POuter_Box_Inventory">
                <div class="row">

                    <div class="col-md-3">
                        Diagnosis :
                    </div>

                    <div class="col-md-5">
                        <input type="text" id="txtDiagnosis" class="required" />
                    </div>


                    <div class="col-md-3">
                        Date :
                    </div>

                    <div class="col-md-5">
                        <asp:TextBox ID="txtDate" runat="server" ToolTip="Click to Select Date" TabIndex="5" ClientIDMode="Static" CssClass="ItDoseTextinputText required"></asp:TextBox>
                        <cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </div>

                    <div class="col-md-3">
                        Patient Blood Type :
                    </div>

                    <div class="col-md-5">
                        <input type="text" id="txtPatientBloodType" class="required" style="display:none;" />
                        
                            <select id="ddlPatientBloodGroup" title="Select Patient Blood Group" ></select>
                    </div>
                </div>

                <div class="row">

                    <div class="col-md-3">
                        Blood Product Transfused :
                    </div>

                    <div class="col-md-5">
                        <input type="text" id="txtBloodProductTransfused" class="required" style="display:none;" />
                        
                            <select id="ddlBloodComponent" title="Select  Blood Component" ></select>
                    </div>


                    <div class="col-md-3">
                        Expiry Date :
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtExpiryDate" runat="server" ToolTip="Click to Select Date" TabIndex="5" ClientIDMode="Static" CssClass="ItDoseTextinputText required"></asp:TextBox>
                        <cc1:CalendarExtender ID="calExpiryDate" runat="server" TargetControlID="txtExpiryDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </div>

                    <div class="col-md-3">
                        Blood Unit :
                    </div>

                    <div class="col-md-5">
                        <input type="text" id="txtBloodUnit" class="required"  />
                    </div>
                </div>

                <div class="row">

                    <div class="col-md-3">
                        Blood Type :
                    </div>

                    <div class="col-md-5">
                        <input type="text" id="txtBloodType"  style="display:none;" />
                        
                            <select id="ddlBloodType" title="Select Patient Blood Group" ></select>
                    </div>


                    <div class="col-md-3">
                        Transfusion Started By :
                    </div>

                    <div class="col-md-5">
                        <select id="ddlTransfusionStratedBy" class="required"></select>
                    </div>

                    <div class="col-md-3">
                        Counter Checked By :
                    </div>

                    <div class="col-md-5">
                        <select id="ddlCounterCheckedBy" class="required"></select>
                    </div>
                </div>

                <div class="row">

                    <div class="col-md-3">
                        Time Transfusion Started :
                    </div>

                    <div class="col-md-3">
                        <input type="text" id="txtTimeTransfusionStarted" class="ItDoseTextinputText TimeField required" />
                    </div>


                    <div class="col-md-3">
                    </div>

                    <div class="col-md-5">
                    </div>

                    <div class="col-md-3">
                    </div>

                    <div class="col-md-5">
                    </div>
                </div>

            </div>
            <div class="POuter_Box_Inventory" style="text-align: left; color: white; background-color: #018eff">
                <b>Observation</b>
            </div>



            <div class="POuter_Box_Inventory">
                <div id="divOutput" style="max-height: 150px; overflow-y: auto; overflow-x: auto;">
                    <table id="tblObservation" rules="all" border="1" style="border-collapse: collapse; width: 100%;" class="GridViewStyle">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">INTERVALS</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">TIME</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">BP</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">TEMP</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">PULSE</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">RESP</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">SPO2</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">REMARK</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">ACTION</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>

            </div>


            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-4">
                        Time Transfusion Ended :
                    </div>
                    <div class="col-md-3">
                        <input type="text" id="txtTimeTransfusionEnded" class="ItDoseTextinputText TimeField required" />
                    </div>

                    <div class="col-md-3">
                    </div>

                    <div class="col-md-3">
                    </div>

                    <div class="col-md-4">
                        Amount Transfused :
                    </div>

                    <div class="col-md-5">
                        <input type="text" id="txtAmountTransfused" class="required" />
                    </div>
                </div>

                <div class="row">

                    <div class="col-md-4">
                        Blood Return To Lab :
                    </div>

                    <div class="col-md-5">
                        <input type="radio" id="rblbrtlYes" name="rblBloodReturnToLab" value="1" />
                        <label for="rblbrtlYes">Yes</label>
                        <input type="radio" id="rblbrtlNo" name="rblBloodReturnToLab" value="0" />
                        <label for="rblbrtlNo">No</label>
                    </div>


                    <div class="col-md-3">
                    </div>

                    <div class="col-md-5">
                    </div>


                </div>

                <div class="row">

                    <div class="col-md-4">
                        Transfusion Reaction :
                    </div>

                    <div class="col-md-5">
                        <input type="radio" id="rblyes" name="rblTransfusionReaction" value="1" onclick="ShowHideReactionFrom(1)" />
                        <label for="rblyes">Yes</label>
                        <input type="radio" id="rblno" name="rblTransfusionReaction" value="0" checked="checked" onclick="ShowHideReactionFrom(0)" />
                        <label for="rblno">No</label>
                    </div>


                    <div class="col-md-3">
                    </div>

                    <div class="col-md-5">
                    </div>


                </div>




            </div>

            <div id="divIsTypeofReaction">
                <div class="POuter_Box_Inventory" style="text-align: left; color: white; background-color: #018eff">
                    <b>If Yes Type Of Reaction</b>
                </div>

                <div class="POuter_Box_Inventory">
                    <div class="row">

                        <div class="col-md-4">
                            General :
                        </div>

                        <div class="col-md-20">
                            <input type="checkbox" id="chkGFever" value="1" />
                            <label for="chkGFever">Fever</label>

                            <input type="checkbox" id="chkGChills" value="1" />
                            <label for="chkGChills">Chills/Rigors</label>

                            <input type="checkbox" id="chkGFlushing" value="1" />
                            <label for="chkGFlushing">Flushing</label>

                            <input type="checkbox" id="chkGVomating" value="1" />
                            <label for="chkGVomating">Nausea/Vomiting</label>
                        </div>



                    </div>

                    <div class="row">

                        <div class="col-md-4">
                            Dermatologic :
                        </div>

                        <div class="col-md-20">
                            <input type="checkbox" id="chkDUrticarial" value="1" />
                            <label for="chkDUrticarial">Urticarial</label>

                            <input type="checkbox" id="chkDRash" value="1" />
                            <label for="chkDRash">Rash</label>

                        </div>



                    </div>

                    <div class="row">

                        <div class="col-md-4">
                            Cardiac/Respiratory :
                        </div>

                        <div class="col-md-20">
                            <input type="checkbox" id="chkRChestPain" value="1" />
                            <label for="chkRChestPain">Chest Pain</label>

                            <input type="checkbox" id="chkRDyspnea" value="1" />
                            <label for="chkRDyspnea">Dyspnea</label>

                            <input type="checkbox" id="chkRHypotension" value="1" />
                            <label for="chkRHypotension">Hypotension</label>

                            <input type="checkbox" id="chkRTchycardia" value="1" />
                            <label for="chkRTchycardia">Tchycardia</label>
                        </div>



                    </div>

                    <div class="row">

                        <div class="col-md-4">
                            Other(Specify):
                             
                        </div>

                        <div class="col-md-8">
                            <textarea id="txtOtherSpecify" cols="10" rows="1"> </textarea>
                        </div>



                    </div>

                </div>



                <div class="POuter_Box_Inventory">


                    <div class="row">

                        <div class="col-md-4">
                            Action Taken :
                        </div>

                        <div class="col-md-8">
                            <textarea id="txtActionTaken" rows="1" cols="10"></textarea>

                        </div>


                        <div class="col-md-6">
                            Transfusion Reaction Form Filled :
                        </div>

                        <div class="col-md-5">
                            <input type="radio" id="rbltrffYes" name="rblTransfusionReactionFormFilled" value="1" />
                            <label for="rbltrffYes">Yes</label>
                            <input type="radio" id="rbltrffNo" name="rblTransfusionReactionFormFilled" value="0" />
                            <label for="rbltrffNo">No</label>
                        </div>
                    </div>

                    <div class="row">

                        <div class="col-md-5">
                            Has Lab Been Contacted :
                        </div>

                        <div class="col-md-19">
                            <input type="radio" id="rblHLBCYes" name="rblHasLabBeenContacted" value="1" />
                            <label for="rblHLBCYes">Yes</label>
                            <input type="radio" id="rblHLBCNo" name="rblHasLabBeenContacted" value="0" />
                            <label for="rblHLBCNo">No</label>
                        </div>



                    </div>

                    <div class="row">

                        <div class="col-md-5">
                            Name :
                        </div>

                        <div class="col-md-5">
                            <input type="text" id="txtCName" />
                        </div>

                        <div class="col-md-3">
                            Date :
                        </div>

                        <div class="col-md-5">
                            <asp:TextBox ID="txtCDate" runat="server" ToolTip="Click to Select Date" TabIndex="5" ClientIDMode="Static" CssClass="ItDoseTextinputText required"></asp:TextBox>
                            <cc1:CalendarExtender ID="calCDate" runat="server" TargetControlID="txtCDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            Time :
                        </div>

                        <div class="col-md-3">
                            <input type="text" id="txtCTime" class="ItDoseTextinputText TimeField required" />
                        </div>


                    </div>

                    <div class="row">

                        <div class="col-md-5">
                            Name Of Nurse/Anesthetist :
                        </div>

                        <div class="col-md-5">
                            <input type="text" id="txtNameOfNurse" />
                        </div>


                        <div class="col-md-3">
                            Sign :
                        </div>

                        <div class="col-md-5">
                            <input type="text" id="txtSigns" class="" />
                        </div>



                    </div>



                </div>
            </div>


            <div class="POuter_Box_Inventory" style="text-align: center;">
                <input type="button" id="btnSave" value="Save" onclick="Save()" style="margin-top: 6px;" />
                 <input type="button" id="btnUpdate" value="Update" onclick="Update()" style="margin-top: 6px;display:none" />
            </div>


            <div class="POuter_Box_Inventory">

                <div id="divtableOutput" style="max-height: 400px; overflow-y: auto; overflow-x: auto;">
                    <table id="tblOutput" rules="all" border="1" style="border-collapse: collapse; width: 100%;" class="GridViewStyle">
                        <thead>

                            <tr>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Diagnosis</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Date</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Patient Blood Type</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Blood Product Transfused</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Expiry Date</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Blood Unit</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Blood Type</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Time Transfusion Started</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Time Transfusion Ended</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Action</th>

                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>

            </div>


        </div>


    </form>


    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css">
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>

    <script type="text/javascript">
        function LoadBloodGroup() {
            serverCall('BloodTransfusionRecords.aspx/LoadBloodGroup', {}, function (response) {
                ddlFromBloodgroup = $('#ddlPatientBloodGroup');
                ddlFromBloodgroup.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BloodGroup', isSearchAble: false });
                ddlFromBloodType = $('#ddlBloodType');
                ddlFromBloodType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BloodGroup', isSearchAble: false });

               });
        }
        function LoadBloodComponent() {
            serverCall('BloodTransfusionRecords.aspx/LoadBloodComponent', {}, function (response) {
                ddlFromBloodgroup = $('#ddlBloodComponent');
                ddlFromBloodgroup.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'ComponentName', isSearchAble: false });
                
            });
        }

        // A $( document ).ready() block.
        $(document).ready(function () {
            LoadBloodGroup();
            LoadBloodComponent();
            DeletePreviousObservationRow();
            $("#txtSigns").val('<%=Util.GetString(Session["EmployeeName"])%>')
            BindEmployee();
            AddNewRow();
            ShowHideReactionFrom(0);
            btnManagment(0);
            $('.TimeField').timepicker({
                timeFormat: 'h:mm p',
                interval: 10,
                minTime: '00:01',
                maxTime: '11:59pm',
                defaultTime: new Date(),
                startTime: '00:01',
                dynamic: false,
                dropdown: true,
                scrollbar: true
            });

            $('#ddlTransfusionStratedBy').prop('disabled', true);
           // $('#ddlCounterCheckedBy').prop('disabled', true);

            Search();          

        });




        function AddNewRow() {

            
            var row = "";

            row += '<tr>';

            row += '<td class="GridViewLabItemStyle" > <input id="txtIntervals" type="text" class="required" /> </td>';
            row += '<td class="GridViewLabItemStyle" >  <input type="text" id="txtObservationTime" class="ItDoseTextinputText TimeField required" /></td>';
            row += '<td class="GridViewLabItemStyle" > <input id="txtBP" type="text" class="required" /> </td>';

            row += '<td class="GridViewLabItemStyle" > <input id="txtTemp" type="text" class="required" /> </td>';
            row += '<td class="GridViewLabItemStyle" > <input id="txtPulse" type="text" class="required" /> </td>';
            row += '<td class="GridViewLabItemStyle" > <input id="txtResp" type="text" class="required" /> </td>';

            row += '<td class="GridViewLabItemStyle" > <input id="txtSPO2" type="text" class="required" /> </td>';
            row += '<td class="GridViewLabItemStyle" > <input id="txtRemark" type="text" />  </td>';
            row += '<td class="GridViewLabItemStyle" style="display:none" > <input id="txtEntryBy" type="text"  />  </td>';

            row += '<td class="GridViewLabItemStyle" ><img id="btnAddNewRow" class="clsbtnAddShow"  src="../../Images/plus_in.gif" style="cursor:pointer" onclick="AddNewRow()"> <img id="btnRemove" class="clsbtnRemoveShow"  src="../../Images/Delete.gif" style="cursor:pointer;" onclick="RemoveRow(this)">  </td>';


            row += '</tr>';


            $("#tblObservation tbody").append(row);

            $('.TimeField').timepicker({
                timeFormat: 'h:mm p',
                interval: 10,
                minTime: '00:01',
                maxTime: '11:59pm',
                defaultTime: new Date(),
                startTime: '00:01',
                dynamic: false,
                dropdown: true,
                scrollbar: true
            });

        }

        function RemoveRow(rowId) {
            $(rowId).closest("tr").remove();

            var rowCount = $('#tblObservation tbody tr').length;
            if (rowCount == 0) {
                AddNewRow();
            }
        }


        function ShowHideReactionFrom(Typ) {

            if (Typ == 1) {
                $("#divIsTypeofReaction").show();
            } else {
                $("#divIsTypeofReaction").hide();
            }

        }



        function BindEmployee() {

            var EmpId = '<%=Session["ID"].ToString()%>';
            serverCall('BloodTransfusionRecords.aspx/BindEmployee', {}, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlTransfusionStratedBy').bindDropDown({
                    data: responseData,
                    valueField: 'Id',
                    textField: 'Name',
                  //  isSearchAble: true,                  
                    defaultValue: 'Select',
                    selectedValue: EmpId
                });

               

                $('#ddlCounterCheckedBy').bindDropDown({
                    defaultValue: 'Select',
                    data: JSON.parse(response),
                    valueField: 'Id',
                    textField: 'Name',
                  //  isSearchAble: true,
                    selectedValue: EmpId
                });

                $('#ddlCounterCheckedBy').chosen();
            });
        }



        function GetRecordDetails() {
            var objRec = new Object();

            var TransfusionReactionFormFilled = $('input[name="rblTransfusionReactionFormFilled"]:checked').val();
            var HasLabBeenContacted = $('input[name="rblHasLabBeenContacted"]:checked').val();

            var BloodReturnToLab = $('input[name="rblBloodReturnToLab"]:checked').val();
            var TransfusionReaction = $('input[name="rblTransfusionReaction"]:checked').val();

            if (TransfusionReactionFormFilled == "" || TransfusionReactionFormFilled == null || TransfusionReactionFormFilled == undefined) {
                TransfusionReactionFormFilled = 2;
            }

            if (HasLabBeenContacted == "" || HasLabBeenContacted == null || HasLabBeenContacted == undefined) {
                HasLabBeenContacted = 2;
            }
            if (BloodReturnToLab == "" || BloodReturnToLab == null || BloodReturnToLab == undefined) {
                BloodReturnToLab = 2;
            }

            if (TransfusionReaction == "" || TransfusionReaction == null || TransfusionReaction == undefined) {
                TransfusionReaction = 2;
            }


            var GFever = 0;
            var GChills = 0;
            var GFlushing = 0;
            var GVomating = 0;
            var DUrticarial = 0;
            var DRash = 0;
            var RChestPain = 0;
            var RDyspnea = 0;
            var RHypotension = 0;
            var RTchycardia = 0;


            if ($('#chkGFever').is(":checked")) {
                GFever = 1;
            }
            if ($('#chkGChills').is(":checked")) {
                GChills = 1;
            }
            if ($('#chkGFlushing').is(":checked")) {
                GFlushing = 1;
            }
            if ($('#chkGVomating').is(":checked")) {
                GVomating = 1;
            }

            if ($('#chkDUrticarial').is(":checked")) {
                DUrticarial = 1;
            }
            if ($('#chkDRash').is(":checked")) {
                DRash = 1;
            }
            if ($('#chkRChestPain').is(":checked")) {
                RChestPain = 1;
            }
            if ($('#chkRDyspnea').is(":checked")) {
                RDyspnea = 1;
            }

            if ($('#chkRHypotension').is(":checked")) {
                RHypotension = 1;
            }
            if ($('#chkRTchycardia').is(":checked")) {
                RTchycardia = 1;
            }

            objRec.Id = $("#spnRecordId").text();
            objRec.PatientId = $("#spnPatientID").text();
            objRec.TransactionId = $("#spnTransactionID").text();
            objRec.Diagnosis = $("#txtDiagnosis").val();
            objRec.Date = $("#txtDate").val();
            //objRec.PatientBloodType = $("#txtPatientBloodType").val();
            objRec.PatientBloodType = $("#ddlPatientBloodGroup").val();
            //objRec.BloodProductTransfused = $("#txtBloodProductTransfused").val();
            objRec.BloodProductTransfused = $("#ddlBloodComponent").val();
            objRec.ExpiryDate = $("#txtExpiryDate").val();
            objRec.BloodUnit = $("#txtBloodUnit").val();
            objRec.BloodType = $("#ddlBloodType").val();

            objRec.TransfusionStratedById = $("#ddlTransfusionStratedBy").val();
            objRec.TransfusionStratedByName = $("#ddlTransfusionStratedBy option:selected").text();
            objRec.CounterCheckedById = $("#ddlCounterCheckedBy").val();
            objRec.CounterCheckedByName = $("#ddlCounterCheckedBy option:selected").text();

            objRec.TimeTransfusionStarted = $("#txtTimeTransfusionStarted").val();
            objRec.TimeTransfusionEnded = $("#txtTimeTransfusionEnded").val();
            objRec.AmountTransfused = $("#txtAmountTransfused").val();
            objRec.BloodReturnToLab = BloodReturnToLab;
            objRec.TransfusionReaction = TransfusionReaction;
            objRec.GFever = GFever;
            objRec.GChills = GChills;
            objRec.GFlushing = GFlushing;
            objRec.GVomating = GVomating;
            objRec.DUrticarial = DUrticarial;
            objRec.DRash = DRash;
            objRec.RChestPain = RChestPain;
            objRec.RDyspnea = RDyspnea;
            objRec.RHypotension = RHypotension;
            objRec.RTchycardia = RTchycardia;
            objRec.OtherSpecify = $("#txtOtherSpecify").val();
            objRec.ActionTaken = $("#txtActionTaken").val();

            objRec.TransfusionReactionFormFilled = TransfusionReactionFormFilled;
            objRec.HasLabBeenContacted = HasLabBeenContacted;

            objRec.CName = $("#txtCName").val();
            objRec.CTime = $("#txtCTime").val();
            objRec.NameOfNurse = $("#txtNameOfNurse").val();
            objRec.Signs = $("#txtSigns").val();
            objRec.CDate = $("#txtCDate").val();

            objRec.IsActive = 1;
            objRec.CentreId = '<%=Util.GetInt(Session["CentreID"].ToString())%>'


            return objRec;
        }


        function GetObservationDetails() {
            var dataObservation = new Array();
            var objObs = new Object();
            $("#tblObservation tbody tr").each(function () {

                var $rowid = $(this).closest("tr");

                objObs.Id = 0;
                objObs.BTRecordId = 0;
                objObs.PatientId = $("#spnPatientID").text();
                objObs.TransactionId = $("#spnTransactionID").text();
                objObs.Intervals = $.trim($rowid.find("#txtIntervals").val());
                objObs.Time = $.trim($rowid.find("#txtObservationTime").val());
                objObs.BP = $.trim($rowid.find("#txtBP").val());
                objObs.Temp = $.trim($rowid.find("#txtTemp").val());
                objObs.Pulse = $.trim($rowid.find("#txtPulse").val());
                objObs.Resp = $.trim($rowid.find("#txtResp").val());
                objObs.SPO2 = $.trim($rowid.find("#txtSPO2").val());
                objObs.Remark = $.trim($rowid.find("#txtRemark").val()); 
                objObs.EntryBy = $.trim($rowid.find("#txtEntryBy").val()); 
                objObs.IsActive = 1;
                objObs.CentreId = '<%=Util.GetInt(Session["CentreID"].ToString())%>';



                dataObservation.push(objObs);
                objObs = new Object();


            });
            return dataObservation;
        }



        function Save() {
            var resultRecords = GetRecordDetails();
            var resultObservation = GetObservationDetails();


            if (resultRecords.Diagnosis == "" || resultRecords.Diagnosis == null || resultRecords.Diagnosis==undefined) {
                modelAlert("Enter Diagnosis.");
                return false;
            }
            if (resultRecords.PatientBloodType == "" || resultRecords.PatientBloodType == null || resultRecords.PatientBloodType == undefined) {
                modelAlert("Enter Patient Blood Type.");
                return false;
            }
            if (resultRecords.BloodProductTransfused == "" || resultRecords.BloodProductTransfused == null || resultRecords.BloodProductTransfused == undefined) {
                modelAlert("Enter Blood Product Transfused .");
                return false;
            }
            if (resultRecords.BloodUnit == "" || resultRecords.BloodUnit == null || resultRecords.BloodUnit == undefined) {
                modelAlert("Enter Blood Unit.");
                return false;
            }
            if (resultRecords.BloodType == "" || resultRecords.BloodType == null || resultRecords.BloodType == undefined) {
                modelAlert("Enter Blood Type.");
                return false;
            }

            if (resultRecords.AmountTransfused == "" || resultRecords.AmountTransfused == null || resultRecords.AmountTransfused == undefined) {
                modelAlert("Enter Amount Transfused.");
                return false;
            }
            if (resultRecords.TransfusionStratedById == "" || resultRecords.TransfusionStratedById == null || resultRecords.TransfusionStratedById == undefined) {
                modelAlert("Select Transfusion Started By.");
                return false;
            }

            if (resultRecords.CounterCheckedById == "" || resultRecords.CounterCheckedById == null || resultRecords.CounterCheckedById == undefined) {
                modelAlert("Select Counter Checked By.");
                return false;
            }
             
            var count = 0;
            var msg = "";
            $.each(resultObservation, function (i, item) {
               
                if (item.Intervals == "" || item.Intervals == null || item.Intervals == undefined) {
                    msg = "Enter Intervals in Row No . "+ (i+1);
                    return false;
                }
                if (item.Time == "" || item.Time == null || item.Time == undefined) {
                    msg = "Select Time in Row No . " + (i + 1);
                    return false;
                }
                if (item.BP == "" || item.BP == null || item.BP == undefined) {
                    msg = "Enter BP in Row No . " + (i + 1);
                    return false;
                }
                if (item.Temp == "" || item.Temp == null || item.Temp == undefined) {
                    msg = "Enter Temp. in Row No . " + (i + 1);
                    return false;
                }
                if (item.Pulse == "" || item.Pulse == null || item.Pulse == undefined) {
                    msg = "Enter Pulse. in Row No . " + (i + 1);
                    return false;
                }
                if (item.Resp == "" || item.Resp == null || item.Resp == undefined) {
                    msg = "Enter Resp. in Row No . " + (i + 1);
                    return false;
                }
                if (item.SPO2 == "" || item.SPO2 == null || item.SPO2 == undefined) {
                    msg = "Enter SPO2. in Row No . " + (i + 1);
                    return false;
                }
            }); 
            if (msg!="") {
                modelAlert(msg);
                return false;
            }

            serverCall('BloodTransfusionRecords.aspx/SaveRecord', { Records: resultRecords, Observation: resultObservation }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {

                    modelAlert(GetData.response, function () {
                        window.location.reload();
                    });
                     

                } else {
                    modelAlert(GetData.response);
                }


            });


        }

        function Search() {

            serverCall('BloodTransfusionRecords.aspx/GetDataDetails', { Pid: $("#spnPatientID").text(), Tid: $("#spnTransactionID").text() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    bindData(responseData.data);
                }
                else {
                    $("#tblOutput tbody").empty();
                }

            });
        }

        function bindData(data) {
            $("#tblOutput tbody").empty();
            $.each(data, function (i, item) {
                var row = "";


                row += "<tr>";
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdId">' + item.Id + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdPatientId">' + item.PatientId + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdTransactionId">' + item.TransactionId + '</label></td>';
                row += '<td class="GridViewItemStyle" > <label id="tdDiagnosis">' + item.Diagnosis + '</label></td>';
                row += '<td class="GridViewItemStyle" > <label id="tdDate">' + item.Date + '</label></td>';
                row += '<td class="GridViewItemStyle" style="display:none;" > <label id="tdPatientBloodType">' + item.PatientBloodType + '</label></td>';
                row += '<td class="GridViewItemStyle"  > <label id="tdPatientBloodType1">' + item.PatientBloodType1 + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none;" > <label id="tdBloodProductTransfused">' + item.BloodProductTransfused + '</label></td>';
                row += '<td class="GridViewItemStyle" > <label id="tdBloodProductTransfused1">' + item.BloodProductTransfused1 + '</label></td>';
                row += '<td class="GridViewItemStyle" > <label id="tdExpiryDate">' + item.ExpiryDate + '</label></td>';
                row += '<td class="GridViewItemStyle" > <label id="tdBloodUnit">' + item.BloodUnit + '</label></td>';
                row += '<td class="GridViewItemStyle" style="display:none" > <label id="tdBloodType">' + item.BloodType + '</label></td>';
                row += '<td class="GridViewItemStyle" > <label id="tdBloodType1">' + item.BloodType1 + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdTransfusionStratedById">' + item.TransfusionStratedById + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdTransfusionStratedByName">' + item.TransfusionStratedByName + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdCounterCheckedById">' + item.CounterCheckedById + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdCounterCheckedByName">' + item.CounterCheckedByName + '</label></td>';
                row += '<td class="GridViewItemStyle" > <label id="tdTimeTransfusionStarted">' + item.TimeTransfusionStarted + '</label></td>';
                row += '<td class="GridViewItemStyle" > <label id="tdTimeTransfusionEnded">' + item.TimeTransfusionEnded + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdAmountTransfused">' + item.AmountTransfused + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdBloodReturnToLab">' + item.BloodReturnToLab + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdTransfusionReaction">' + item.TransfusionReaction + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdGFever">' + item.GFever + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdGChills">' + item.GChills + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdGFlushing">' + item.GFlushing + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdGVomating">' + item.GVomating + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdDUrticarial">' + item.DUrticarial + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdDRash">' + item.DRash + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdRChestPain">' + item.RChestPain + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdRDyspnea">' + item.RDyspnea + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdRHypotension">' + item.RHypotension + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdRTchycardia">' + item.RTchycardia + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdOtherSpecify">' + item.OtherSpecify + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdActionTaken">' + item.ActionTaken + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdTransfusionReactionFormFilled">' + item.TransfusionReactionFormFilled + '</label></td>';

                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdHasLabBeenContacted">' + item.HasLabBeenContacted + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdCName">' + item.CName + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdCTime">' + item.CTime + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdNameOfNurse">' + item.NameOfNurse + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdSigns">' + item.Signs + '</label></td>';
                row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdCDate">' + item.CDate + '</label></td>';

                row += '<td class="GridViewItemStyle"   > <img id="btnEdit"  src="../../Images/edit.png" style="cursor:pointer" onclick="Edit(this)">  </td>';

                row += "</tr>";

                $("#tblOutput tbody").append(row);
            });

        }












        function Edit(rowId) {

            var $rowid = $(rowId).closest("tr");


            var Id = $.trim($rowid.find("#tdId").text());

            var Diagnosis = $.trim($rowid.find("#tdDiagnosis").text());
            var Date = $.trim($rowid.find("#tdDate").text());
            var PatientBloodType = $.trim($rowid.find("#tdPatientBloodType").text());
            var BloodProductTransfused = $.trim($rowid.find("#tdBloodProductTransfused").text());
            var ExpiryDate = $.trim($rowid.find("#tdExpiryDate").text());
            var BloodUnit = $.trim($rowid.find("#tdBloodUnit").text());
            var BloodType = $.trim($rowid.find("#tdBloodType").text());
            var TransfusionStratedById = $.trim($rowid.find("#tdTransfusionStratedById").text());
            var TransfusionStratedByName = $.trim($rowid.find("#tdTransfusionStratedByName").text());
            var CounterCheckedById = $.trim($rowid.find("#tdCounterCheckedById").text());
            var CounterCheckedByName = $.trim($rowid.find("#tdCounterCheckedByName").text());
            var TimeTransfusionStarted = $.trim($rowid.find("#tdTimeTransfusionStarted").text());
            var TimeTransfusionEnded = $.trim($rowid.find("#tdTimeTransfusionEnded").text());
            var AmountTransfused = $.trim($rowid.find("#tdAmountTransfused").text());
            var BloodReturnToLab = $.trim($rowid.find("#tdBloodReturnToLab").text());
            var TransfusionReaction = $.trim($rowid.find("#tdTransfusionReaction").text());
            var GFever = $.trim($rowid.find("#tdGFever").text());
            var GChills = $.trim($rowid.find("#tdGChills").text());
            var GFlushing = $.trim($rowid.find("#tdGFlushing").text());
            var GVomating = $.trim($rowid.find("#tdGVomating").text());
            var DUrticarial = $.trim($rowid.find("#tdDUrticarial").text());
            var DRash = $.trim($rowid.find("#tdDRash").text());
            var RChestPain = $.trim($rowid.find("#tdRChestPain").text());
            var RDyspnea = $.trim($rowid.find("#tdRDyspnea").text());
            var RHypotension = $.trim($rowid.find("#tdRHypotension").text());
            var RTchycardia = $.trim($rowid.find("#tdRTchycardia").text());
            var OtherSpecify = $.trim($rowid.find("#tdOtherSpecify").text());
            var ActionTaken = $.trim($rowid.find("#tdActionTaken").text());
            var TransfusionReactionFormFilled = $.trim($rowid.find("#tdTransfusionReactionFormFilled").text());
            var HasLabBeenContacted = $.trim($rowid.find("#tdHasLabBeenContacted").text());
            var CName = $.trim($rowid.find("#tdCName").text());
            var CTime = $.trim($rowid.find("#tdCTime").text());
            var NameOfNurse = $.trim($rowid.find("#tdNameOfNurse").text());
            var Signs = $.trim($rowid.find("#tdSigns").text());
            var CDate = $.trim($rowid.find("#tdCDate").text());
            $("#spnRecordId").text(Id);
            $("#txtDiagnosis").val(Diagnosis);
            $("#txtDate").val(Date);
           // $("#txtPatientBloodType").val(PatientBloodType);
            $("#ddlPatientBloodGroup").val(PatientBloodType);
            //$("#txtBloodProductTransfused").val(BloodProductTransfused);
            $("#ddlBloodComponent").val(BloodProductTransfused);
            $("#txtExpiryDate").val(ExpiryDate);
            $("#txtBloodUnit").val(BloodUnit);
            $("#ddlBloodType").val(BloodType);

            $("#ddlTransfusionStratedBy").val(TransfusionStratedById);

            $("#ddlCounterCheckedBy").val(CounterCheckedById);
            $("#txtTimeTransfusionStarted").val(TimeTransfusionStarted);
            $("#txtTimeTransfusionEnded").val(TimeTransfusionEnded);
            $("#txtAmountTransfused").val(AmountTransfused);
            $("#txtOtherSpecify").val(OtherSpecify);
            $("#txtActionTaken").val(ActionTaken);

            $("#txtCName").val(CName);
            $("#txtCTime").val(CTime);
            $("#txtNameOfNurse").val(NameOfNurse);
            $("#txtSigns").val(Signs);
            $("#txtCDate").val(CDate);


            GetObservationData(Id);
            if (GFever == 1) {
                $("#chkGFever").prop('checked', true);
            } else {
                $("#chkGFever").prop('checked', false);
            }


            if (GChills == 1) {

                $("#chkGChills").prop('checked', true);
            } else {
                $("#chkGChills").prop('checked', false);
            }


            if (GFlushing == 1) {

                $("#chkGFlushing").prop('checked', true);
            }
            else {
                $("#chkGFlushing").prop('checked', false);
            }

            if (GVomating == 1) {

                $("#chkGVomating").prop('checked', true);
            } else {

                $("#chkGVomating").prop('checked', false);
            }



            if (DUrticarial == 1) {

                $("#chkDUrticarial").prop('checked', true);
            } else {
                $("#chkDUrticarial").prop('checked', false);
            }


            if (DRash == 1) {

                $("#chkDRash").prop('checked', true);
            } else {
                $("#chkDRash").prop('checked', false);
            }



            if (RChestPain == 1) {

                $("#chkRChestPain").prop('checked', true);
            }
            else {

                $("#chkRChestPain").prop('checked', false);
            }

            if (RDyspnea == 1) {
                $("#chkRDyspnea").prop('checked', true);
            }
            else {
                $("#chkRDyspnea").prop('checked', false);
            }

            if (RHypotension == 1) {
                $("#chkRHypotension").prop('checked', true);
            } else {
                $("#chkRHypotension").prop('checked', false);
            }


            if (RTchycardia == 1) {

                $("#chkRTchycardia").prop('checked', true);
            } else {
                $("#chkRTchycardia").prop('checked', false);
            }
             

            $("input[name=rblTransfusionReactionFormFilled][value=" + TransfusionReactionFormFilled + "]").prop('checked', true);
            $("input[name=rblHasLabBeenContacted][value=" + HasLabBeenContacted + "]").prop('checked', true);
            $("input[name=rblBloodReturnToLab][value=" + BloodReturnToLab + "]").prop('checked', true);
            $("input[name=rblTransfusionReaction][value=" + TransfusionReaction + "]").prop('checked', true); 
            ShowHideReactionFrom(TransfusionReaction);
            btnManagment(1);
        }



        function GetObservationData(Id) {

            serverCall('BloodTransfusionRecords.aspx/GetObservationData', { RecId:Id}, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    bindNewrow(responseData.data);
                }
                else {
                    $("#tblOutput tbody").empty();
                }

            });
        }

         
        function bindNewrow(data) {

            DeletePreviousObservationRow();
            $.each(data, function (i, item) {

                var row = "";

                row += '<tr>';

                row += '<td class="GridViewLabItemStyle" > <input id="txtIntervals" type="text" class="required" value="' + item.Intervals + '" /> </td>';
                row += '<td class="GridViewLabItemStyle" >  <input type="text" id="txtObservationTime" class="ItDoseTextinputText TimeField required" value="' + item.Time+ '" /></td>';
                row += '<td class="GridViewLabItemStyle" > <input id="txtBP" type="text" class="required" value="' + item.BP + '" /> </td>';

                row += '<td class="GridViewLabItemStyle" > <input id="txtTemp" type="text" class="required" value="' + item.Temp + '" /> </td>';
                row += '<td class="GridViewLabItemStyle" > <input id="txtPulse" type="text" class="required" value="' + item.Pulse + '" /> </td>';
                row += '<td class="GridViewLabItemStyle" > <input id="txtResp" type="text" class="required" value="' + item.Resp + '" /> </td>';

                row += '<td class="GridViewLabItemStyle" > <input id="txtSPO2" type="text" class="required" value="' + item.SPO2 + '" /> </td>';
                row += '<td class="GridViewLabItemStyle" > <input id="txtRemark" type="text" value="' + item.Remark + '" />  </td>';
                row += '<td class="GridViewLabItemStyle" style="display:none" > <input id="txtEntryBy" type="text" value="' + item.EntryBy + '" />  </td>';
                if ((i + 1) == data.length) {
                    row += '<td class="GridViewLabItemStyle" ><img id="btnAddNewRow" class="clsbtnAddShow"  src="../../Images/plus_in.gif" style="cursor:pointer" onclick="AddNewRow()"> <img id="btnRemove" class="clsbtnRemoveShow"  src="../../Images/Delete.gif" style="cursor:pointer;" onclick="RemoveRow(this)">  </td>';

                }
                else {
                    row += '<td class="GridViewLabItemStyle" ><img id="btnAddNewRow" class="clsbtnAddShow"  src="../../Images/plus_in.gif" style="cursor:pointer;" onclick="AddNewRow()"  > <img id="btnRemove" class="clsbtnRemoveShow"  src="../../Images/Delete.gif" style="cursor:pointer;" onclick="RemoveRow(this)">  </td>';

                }

                row += '</tr>';


                $("#tblObservation tbody").append(row);
            });

            
            $('.TimeField').timepicker({
                timeFormat: 'h:mm p',
                interval: 10,
                minTime: '00:01',
                maxTime: '11:59pm',
               // defaultTime: new Date(),
                startTime: '00:01',
                dynamic: false,
                dropdown: true,
                scrollbar: true
            });

        }


        function DeletePreviousObservationRow() {
            $('#tblObservation tbody').empty(); 
        }





        function Update() {
            var resultRecords = GetRecordDetails();
            var resultObservation = GetObservationDetails();


            if (resultRecords.Diagnosis == "" || resultRecords.Diagnosis == null || resultRecords.Diagnosis == undefined) {
                modelAlert("Enter Diagnosis.");
                return false;
            }
            if (resultRecords.PatientBloodType == "" || resultRecords.PatientBloodType == null || resultRecords.PatientBloodType == undefined) {
                modelAlert("Enter Patient Blood Type.");
                return false;
            }
            if (resultRecords.BloodProductTransfused == "" || resultRecords.BloodProductTransfused == null || resultRecords.BloodProductTransfused == undefined) {
                modelAlert("Enter Blood Product Transfused .");
                return false;
            }
            if (resultRecords.BloodUnit == "" || resultRecords.BloodUnit == null || resultRecords.BloodUnit == undefined) {
                modelAlert("Enter Blood Unit.");
                return false;
            }
            if (resultRecords.BloodType == "" || resultRecords.BloodType == null || resultRecords.BloodType == undefined) {
                modelAlert("Enter Blood Type.");
                return false;
            }

            if (resultRecords.AmountTransfused == "" || resultRecords.AmountTransfused == null || resultRecords.AmountTransfused == undefined) {
                modelAlert("Enter Amount Transfused.");
                return false;
            }
            if (resultRecords.TransfusionStratedById == "" || resultRecords.TransfusionStratedById == null || resultRecords.TransfusionStratedById == undefined) {
                modelAlert("Select Transfusion Started By.");
                return false;
            }

            if (resultRecords.CounterCheckedById == "" || resultRecords.CounterCheckedById == null || resultRecords.CounterCheckedById == undefined) {
                modelAlert("Select Counter Checked By.");
                return false;
            }

            

            serverCall('BloodTransfusionRecords.aspx/UpdateRecord', { Records: resultRecords, Observation: resultObservation }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {

                    modelAlert(GetData.response, function () { 
                        window.location.reload(); 
                    });

                } else {
                    modelAlert(GetData.response);
                }


            });


        }

        function btnManagment(Typ) {

            if (Typ == 1) {

                $("#btnSave").hide();
                $("#btnUpdate").show();
            } else {
                $("#btnSave").show();
                $("#btnUpdate").hide();
            }
        }

        



    </script>





</body>
</html>
