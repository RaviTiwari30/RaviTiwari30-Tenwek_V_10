<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientIPDDischarge.aspx.cs"
    Inherits="Design_IPD_PatientIPDDischarge" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/StartDate.ascx" TagName="StartDate" TagPrefix="uc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagName="StartTime" TagPrefix="uc2" %>

<%@ Register Src="~/Design/Controls/wuc_IPDBillDetail.ascx" TagName="IPDBillDetail" TagPrefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
   
    <script src="../../Scripts/Message.js" type="text/javascript"></script>


</head>
<body>
        <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" >
        $(document).ready(function () {
            discharge();
            IsSelected();
            UserRemark();
        });
        function IsSelected() {
           
            var ddltype = document.getElementById('<%=ddlType.ClientID%>');
            var ddltxt = ddltype.options[ddltype.selectedIndex].text;

            var TID='<%=Request.QueryString["TransactionID"].ToString()%>';
            serverCall('PatientIPDDischarge.aspx/CheckICD', { TID: TID }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status == false) {

                    modelAlert("Please Enter Final Diagnosis Information. After that, you can discharge intimate.");
                }
                else {
                    if (ddltxt == "SELECT") {

                        modelAlert('Please Select Discharge Type');
                        $("#btnDisIntimate").hide();

                    } else {
                        $('#lblMsg').text('');
                        $("#btnDisIntimate").show();
                    }
                }

            });
            
            
            discharge();
        }


        function UserRemark() {
            $.ajax({
                url: "Services/IPD.asmx/bindUserRemarks",
                data: '{TID:"' + $('#lblTID').text() + '" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                   BillingComment = result.d;
                   if (BillingComment != "") {
                       modelAlert("Remarks : "+ BillingComment);
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function discharge() {

            var ddltype = document.getElementById('<%=ddlType.ClientID%>');
            var ddltxt = ddltype.options[ddltype.selectedIndex].text;

            if (ddltxt == "Death") {
                $("#<%=PanelDeath.ClientID %>").show();
                $('#divTransferOnRequest').hide();
            }

            else if ($('#btnDischarge').val() == "Discharge" && ddltxt == "Transfer On Requrest")
            {
               
                $('#divTransferOnRequest').show();
                $('#ddlInchargeDoctor').chosen();
                $('#ddlRefferingHospital').chosen();
                $("#<%=PanelDeath.ClientID %>").hide();

            }

            else {
                $("#<%=PanelDeath.ClientID %>").hide();
                $('#divTransferOnRequest').hide();
            }
        }
        function validate(btn) {
            var ddltype = document.getElementById('<%=ddlType.ClientID%>');
            var ddltxt = ddltype.options[ddltype.selectedIndex].text;
            
            if (ddltxt == "Expired") {
                if ($('#txtcauseOfDeath').is(':visible') == true && $('#txtcauseOfDeath').val() == "") {
                    modelAlert('Please Enter Cause Of Death');
                    return false;
                }

            }


            else {
                $('#lblMsg').text('');
            }
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('btnNarSave', '');
        }
        function popup() {

            if (parseFloat($('#<%=IPDBillDetail.FindControl("lblBalanceAmt").ClientID %>').text()) > 0) {
                $('.hdnbalance').val($('#<%=IPDBillDetail.FindControl("lblBalanceAmt").ClientID %>').text());
                $('#lblBal').text('Remaining Balance Of Patient Is (' + $('#<%=IPDBillDetail.FindControl("lblBalanceAmt").ClientID %>').text() + ') Are You Sure You Want To Discharge ?');
            }
            var ddltype = document.getElementById('<%=ddlType.ClientID%>');
            var ddltxt = ddltype.options[ddltype.selectedIndex].text;
            if (ddltxt == "Expired") {
                if ($('#txtcauseOfDeath').is(':visible') == true && $('#txtcauseOfDeath').val() == '') {
                    $('#lblMsg').text('Please Enter Cause Of Death');
                    $find('<%=mpNarration.ClientID%>').hide();
                    return false;
                }
            }
            else {
                $('#lblMsg').text('');
                $find('<%=mpNarration.ClientID%>').show();
            }

        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpNarration")) {
                    $find("mpNarration").hide();
                }

            }

        }

        function closeDischargeIntimation() {
            if ($find("mpNarration")) {
                $find("mpNarration").hide();
            }
        }
        function Discharge(btn) {
            var ddltxt = $('#ddlType').val();
            var InchargeDoctor = $('#ddlInchargeDoctor').val();
            var ReffereingHospital = $('#ddlRefferingHospital').val();
            if (ddltxt == "Transfer On Requrest") {


                if (ReffereingHospital == "0" || ReffereingHospital == null) {
                    modelAlert("Please Selected Reffering Hospital ", function () { $('#ddlRefferingHospital').focus(); });
                    return false;
                }
                else if (InchargeDoctor == "0" || InchargeDoctor == null) {
                    modelAlert("Please Selected Incharge Doctor", function () { $('#ddlInchargeDoctor').focus(); });
                    return false;
                }
                else if ($('#txtDiagnosisReason').val() == "") {
                    modelAlert("If Your Discharge Type Is Patient On Request,Please Enter Diagnosis Reason", function () { $('#txtDiagnosisReason').focus(); });
                    return false;
                }
            }
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('btnDischarge', '');
        }

        function wopen(url, name, w, h) {

            //w += 200;
            //h += 100;
            var win = window.open(url, name, 'width=' + w + ', height=' + h + ', ' + 'location=no, menubar=no, ' + 'status=no, toolbar=no, scrollbars=no, resizable=no');
            win.resizeTo(w, h);
            win.moveTo(10, 100);
            win.focus();
        }
    

        function OpenVitalPage(el) {
            var TID = '<%=Request.QueryString["TransactionID"].ToString()%>';
            var PID = '<%=Request.QueryString["PID"].ToString()%>';
            var Gender = '<%=Request.QueryString["Sex"].ToString()%>';
            wopen('../IPD/IPD_Patient_ObservationChart.aspx?TID=' + TID + '&TransactionID=' + TID + '&App_ID=&PID=' + PID + '&PatientId=' + PID + '&Sex=' + Gender + '&IsIPDData, popup1', 5000, 1200);
        }
    </script>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Patient IPD Discharge</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <uc3:IPDBillDetail ID="IPDBillDetail" runat="server" />
                <asp:Label ID="lblTID" runat="server" Style="display: none"></asp:Label>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="width: 19%" align="right">Discharge :&nbsp;
                        </td>
                        <td style="width: 30%" align="left">
                            <asp:DropDownList ID="ddlType" runat="server" Width="200px" onchange="IsSelected()" ClientIDMode="Static"  CssClass="requiredField"/>
                        </td>
                        <td style="width: 20%; text-align: right;" align="left"></td>
                        <td style="width: 30%" align="left"></td>
                    </tr>
                    <tr>
                        <td style="width: 19%" align="right">Date :&nbsp;
                        </td>
                        <td style="width: 30%" align="left">
                            <%--   <uc1:StartDate ID="txtDate" runat="server" />--%>
                            <asp:TextBox ID="txtDate" runat="server" Width="110px"></asp:TextBox>
                            <cc1:CalendarExtender ID="calStartDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtDate"></cc1:CalendarExtender>

                        </td>
                        <td style="width: 20%; text-align: right;" align="left">Time :
                        </td>
                        <td style="width: 30%" align="left">
                            
                            <uc2:StartTime ID="StartTime" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
            <asp:Panel ID="PanelDeath" runat="server" Style="display: none" Width="955px">
                <div class="POuter_Box_Inventory">
                    <div class="content" style="text-align: center;">
                        <table style="width: 100%">
                            <tr>
                                <td style="width: 20%; text-align: right">
                                    <asp:Label ID="lblDateofdeath" runat="server" Text="Date Of Death"></asp:Label>
                                    :
                                </td>
                                <td style="width: 30%; text-align: left">
                                    <uc1:StartDate ID="EntryDateDeath" runat="server" />
                                </td>
                                <td style="width: 20%; text-align: right">
                                    <asp:Label ID="lblTime" runat="server" Text="Time"></asp:Label>
                                    :
                                </td>
                                <td style="width: 30%; text-align: left;">
                                    <uc2:StartTime ID="EntryTimeDeath" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 20%; text-align: right">
                                    <asp:Label ID="lblCauseOfDeath" runat="server" Text="Cause Of Death"></asp:Label>
                                    :
                                </td>
                                <td style="width: 30%; text-align: left">
                                    <asp:TextBox ID="txtcauseOfDeath" runat="server" ToolTip="Enter Cause Of Death" ClientIDMode="Static"
                                        MaxLength="50" Width="147px" />
                                    <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                </td>
                                <td style="width: 20%; text-align: right">
                                    <asp:Label ID="lblremarks" runat="server" Text="Remarks"></asp:Label>
                                    :
                                </td>
                                <td style="width: 30%; text-align: left">
                                    <asp:TextBox ID="txtRemarks" runat="server" ToolTip="Enter Remarks" MaxLength="50"
                                        Width="139px" />
                                </td>
                            </tr>
                            <tr style="display:none;">
                                <td style="width: 20%; text-align: right">
                                    <asp:Label ID="lbltypeOfDeath" runat="server" Text="Type Of Death"></asp:Label>
                                    :
                                </td>
                                <td style="width: 30%; text-align: left">
                                    <asp:DropDownList ID="ddltypeOfDeath" runat="server" Width="152px" ToolTip="Select Type Of Death">
                                    </asp:DropDownList>
                                    <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                </td>
                                <td style="width: 20%; text-align: right"></td>
                                <td style="width: 30%; text-align: left">
                                    <asp:CheckBox ID="chkDeathover48hrs" runat="server" Text="Death Over 48hrs" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </asp:Panel>
            <div class="POuter_Box_Inventory" id="divTransferOnRequest">
                <div class="Purchaseheader">Patient Internal Transfer Request</div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">Name Of Caller</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtNameofcaller" runat="server" ToolTip="Please Enter Caller Name"></asp:TextBox>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">Return Phone No</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtReturnPhoneNo" runat="server" onlynumber="10" ClientIDMode="Static"></asp:TextBox>
                    </div>
                    <div class="col-md-6"></div>
                    
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">Reffering Hospital</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlRefferingHospital" runat="server"  ClientIDMode="Static" CssClass="requiredField"></asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">Incharge Doctor</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlInchargeDoctor" runat="server" ClientIDMode="Static" CssClass="requiredField"></asp:DropDownList>
                    </div>
                    <div class="col-md-2"></div>
                    <div class="col-md-4">

                        <input type="button" id="btnVital" title="Enter Vital" value="Enter Vital" onclick="OpenVitalPage();" class="ItDoseButton" />
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">Daignosis Reason</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-20">
                        <asp:TextBox ID="txtDiagnosisReason" runat="server" ToolTip="Please Enter Patient Diagnosis Reason" CssClass="requiredField" ClientIDMode="Static"></asp:TextBox>

                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">Management Done</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-20">
                        <asp:TextBox ID="txtManagementReason" runat="server" ToolTip="Please Enter Reason"></asp:TextBox>

                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">Need ICU/HUD</label>
       
                    </div>
                    <div class="col-md-20">
                        <asp:CheckBox ID="chkUseICU" runat="server" ToolTip="If You Need ICU/HDU" />

                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
               
                    <asp:Button ID="btnDischarge" runat="server" OnClick="btnDischarge_Click" Text="Discharge"
                        CssClass="ItDoseButton" OnClientClick="return Discharge(this)" />
                    <asp:Button ID="btnDisIntimate" runat="server" Text="Discharge Intimation" CssClass="ItDoseButton"
                        OnClientClick="return popup();" /> 
                
            </div>
            <asp:Label ID="lblPatientID" runat="server" CssClass="general3" Visible="False"></asp:Label>
            <asp:Label ID="lblPanelID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblRoom_ID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblTransactionNo" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblIPDCaseTypeID" runat="server" Visible="False"></asp:Label>
        </div>
        <asp:Panel ID="pnlDisIntimate" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none"
            Width="666px">
            <div class="Purchaseheader" id="Div1" runat="server">
                Discharge Intimation &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; 
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  <em><span style="font-size: 7.5pt" class="shat">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" alt="" onclick="closeDischargeIntimation()" />
                      to close</span></em>
            </div>
            <table style="width: 91%">
                <tr>
                    <td colspan="4">
                        <input type="hidden" id="hdnbalance" class="hdnbalance" runat="server" value="0.00" />
                        <asp:Label ID="lblBal" runat="server" Font-Bold="true" CssClass="ItDoseLblError"></asp:Label></td>
                </tr>
                <tr>
                    <td style="width: 7%; text-align: right">Date :&nbsp;</td>
                    <td style="width: 11%">
                        <%--<uc1:StartDate ID="EntryDate1" runat="server" />--%>
                        <asp:TextBox ID="EntryDate1" runat="server" Width="90px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calStartDate2" runat="server" Format="dd-MMM-yyyy" TargetControlID="EntryDate1"></cc1:CalendarExtender>
                        &nbsp;</td>
                    <td style="width: 5%">Time :</td>
                    <td style="width: 25%">
                        <uc2:StartTime ID="EntryTime1" runat="server" />
                    </td>
                </tr>
            </table>

            <div class="filterOpDiv">
                <asp:Button ID="btnNarSave" runat="server" Text="Save" CssClass="ItDoseButton"
                    OnClick="btnNarSave_Click" OnClientClick="return validate(this);" />
                &nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnNarCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" />
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpNarration" runat="server" CancelControlID="btnNarCancel"
            DropShadow="true" TargetControlID="btnDisIntimate" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlDisIntimate" BehaviorID="mpNarration" PopupDragHandleControlID="dragHandle" ClientIDMode="Static" />
    </form>
</body>
</html>
