<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DischargeCheckList.aspx.cs" Inherits="Design_IPD_DischargeCheckList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">


<head runat="server">
    <title></title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Discharge Patient CheckList</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="col-md-24">
                    <div class="row">
                        <div class="row" style="display:none;">
                            <div class="col-md-3">
                                <label class="pull-left">Date</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                                <cc1:CalendarExtender ID="caldate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Time
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtTime" runat="server" Width="90px"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A-AM/P-PM)</span></em>
                            </div>
                            <div class="col-md-3">
                            </div>
                            <div class="col-md-5">
                            </div>
                        </div>
                       
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Patient & Relatives aware about discharge</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                 <input type="radio" name="rdoAware" value="1" />Yes
                                <input type="radio" name="rdoAware" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtAwareRemarks" />
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left"> Consumabled Indented</label>
                            </div>
                            <div class="col-md-3">
                                <input type="radio" name="rdoConsumables" value="1" />Yes
                                <input type="radio" name="rdoConsumables" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtConsumablesRemarks" />
                            </div>
                        </div>
                      
                          <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Drugs Return to Pharmacy Prior to Discharge</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                 <input type="radio" name="rdoDrugsReturn" value="1" />Yes
                                <input type="radio" name="rdoDrugsReturn" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtDrugsReturnRemarks" />
                            </div>
                            <div class="col-md-5">
                                 <label class="pull-left">T.T.O Supplied and Health Insurance given</label>
                            </div>
                            <div class="col-md-3">
                                <input type="radio" name="rdoTTO" value="1" />Yes
                                <input type="radio" name="rdoTTO" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtTTORemarks" />
                            </div>
                        </div>
                            <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">|Ensure Discharge Summary,Copies of all Investigation given and signed
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                 <input type="radio" name="rdoEnsureDS" value="1" />Yes
                                <input type="radio" name="rdoEnsureDS" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtEnsureDSRemarks" />
                            </div>
                            <div class="col-md-5">
                             <label class="pull-left">Signed Pfe form handed over to patient, Stroke Leaflet given as applicable, smoking sessation leaflet given as applicable</label>
                            </div>
                            <div class="col-md-3">
                                <input type="radio" name="rdoSigned" value="1" />Yes
                                <input type="radio" name="rdoSigned" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtSignedRemarks" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Refferal for follow up arranged if required
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                 <input type="radio" name="rdoRefferal" value="1" />Yes
                                <input type="radio" name="rdoRefferal" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtRefferalRemarks" />
                            </div>
                            <div class="col-md-5">
                               <label class="pull-left">  Venflon or Cannula removed</label>
                            </div>
                            <div class="col-md-3">
                                <input type="radio" name="rdoVenflon" value="1" />Yes
                                <input type="radio" name="rdoVenflon" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtVenflonRemarks" />
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Wound Site checked if Applicable
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                 <input type="radio" name="rdoWound" value="1" />Yes
                                <input type="radio" name="rdoWound" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtWoundRemarks" />
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left"> Discharge log booked applicable and signed</label>
                            </div>
                            <div class="col-md-3">
                                <input type="radio" name="rdoDisLog" value="1" />Yes
                                <input type="radio" name="rdoDisLog" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtDisLogRemakrs" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Ensure for billing
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                 <input type="radio" name="rdoEnsureBilling" value="1" />Yes
                                <input type="radio" name="rdoEnsureBilling" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtEnsureBillingRemarks" />
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left"> checkout of patient</label>
                            </div>
                            <div class="col-md-3">
                                <input type="radio" name="rdoCheckout" value="1" />Yes
                                <input type="radio" name="rdoCheckout" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtCheckoutRemarks" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div class="POuter_Box_Inventory">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-10">
                            <label id="lblID" style="display:none"></label>
                            <label id="lblCreateDate" style="display:none"></label>
                        </div>
                        <div class="col-md-4">
                            <input type="button" id="btnSave" value="Save" title="Click to Save" class="ItDoseButton" onclick="SaveRecord();" />
                            <input type="button" id="btnUpdate" value="Update" title="Click to Update" class="ItDoseButton" onclick="UpdateRecord();" style="display: none" />
                            <asp:Button ID="btnPrint" runat="server" Text="Print" ClientIDMode="Static" ToolTip="Click to Print" CssClass="ItDoseButton" OnClick="btnPrint_Click" />
                        </div>
                        <div class="col-md-10"></div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script type="text/javascript">
    $(document).ready(function () {
        BindPatientData();
    });

    function BindPatientData() {
        var TID = '<%=Request.QueryString["TransactionID"]%>';
        var PID = '<%=Request.QueryString["PatientId"]%>';
        serverCall('DischargeCheckList.aspx/BindPatientDetail', { TID: TID }, function (response) {
            StockData = jQuery.parseJSON(response);
            if (StockData.length!="0") {
                $('input[name="rdoAware"]').filter("[value='" + StockData[0].IsAware + "']").attr('checked', true);
                $('input[name="rdoConsumables"]').filter("[value='" + StockData[0].IsConsumables + "']").attr('checked', true);
                $('input[name="rdoDrugsReturn"]').filter("[value='" + StockData[0].IsDrugsReturn + "']").attr('checked', true);
                $('input[name="rdoTTO"]').filter("[value='" + StockData[0].IsTTO + "']").attr('checked', true);
                $('input[name="rdoEnsureDS"]').filter("[value='" + StockData[0].IsEnsureDS + "']").attr('checked', true);
                $('input[name="rdoSigned"]').filter("[value='" + StockData[0].IsSigned + "']").attr('checked', true);
                $('input[name="rdoRefferal"]').filter("[value='" + StockData[0].IsRefferal + "']").attr('checked', true);
                $('input[name="rdoVenflon"]').filter("[value='" + StockData[0].IsVenflon + "']").attr('checked', true);
                $('input[name="rdoWound"]').filter("[value='" + StockData[0].IsWound + "']").attr('checked', true);
                $('input[name="rdoDisLog"]').filter("[value='" + StockData[0].IsDischrageLog + "']").attr('checked', true);
                $('input[name="rdoEnsureBilling"]').filter("[value='" + StockData[0].IsEnsureBilling + "']").attr('checked', true);
                $('input[name="rdoCheckout"]').filter("[value='" + StockData[0].IsCheckout + "']").attr('checked', true);

                $('#txtAwareRemarks').val(StockData[0].AwareRemarks);
                $('#txtConsumablesRemarks').val(StockData[0].ConsumablesRemarks);
                $('#txtDrugsReturnRemarks').val(StockData[0].DrugsReturnRemarks);
                $('#txtTTORemarks').val(StockData[0].TTORemarks);
                $('#txtEnsureDSRemarks').val(StockData[0].EnsureDSRemarks);
                $('#txtSignedRemarks').val(StockData[0].SignedRemarks)

                $('#txtRefferalRemarks').val(StockData[0].RefferalRemarks);
                $('#txtVenflonRemarks').val(StockData[0].VenflonRemarks);
                $('#txtWoundRemarks').val(StockData[0].WoundRemarks);
                $('#txtDisLogRemakrs').val(StockData[0].DischargeLogRemarks);
                $('#txtEnsureBillingRemarks').val(StockData[0].EnsureBillingRemarks);
                $('#txtCheckoutRemarks').val(StockData[0].CheckoutRemarks)

                $('#lblCreateDate').text(StockData[0].CreateDate);
                $('#lblID').text(StockData[0].ID);
                if (StockData[0].ID != null || StockData[0].ID != "") {
                    $('#btnUpdate').show();
                    $('#btnSave').hide();
                }
                else {
                    $('#btnSave').show();
                }
                if (StockData[0].IsEdit == "0") {
                    $('#btnUpdate').hide();
                    $('#btnSave').hide();
                    $('#lblMsg').text('Time Out Expired !!!');
                }
            }
        });
    }

    function SaveRecord() {
        var resultData = getData();
        var TID = '<%=Request.QueryString["TransactionID"]%>';
        var PID = '<%=Request.QueryString["PatientId"]%>';
        serverCall('DischargeCheckList.aspx/SaveCheckList', { Data: resultData, TID: TID, PID: PID }, function (response) {
            var result = parseInt(response);
            if (result == 1)
                modelAlert('Record Save Successfully');
            else
                modelAlert('Error Occured');
        });
    }

    function getData()
    {
        var data = new Array();
        var Obj = new Object();
        
        Obj.IsAware = $('input[name=rdoAware]:checked').val();
        Obj.AwareRemarks = $('#txtAwareRemarks').val();
        Obj.IsConsumables = $('input[name=rdoConsumables]:checked').val();
        Obj.ConsumablesRemarks = $('#txtConsumablesRemarks').val();
        Obj.IsDrugsReturn = $('input[name=rdoDrugsReturn]:checked').val();
        Obj.DrugsReturnRemarks = $('#txtDrugsReturnRemarks').val();
        Obj.IsTTO = $('input[name=rdoTTO]:checked').val();
        Obj.TTORemarks = $('#txtTTORemarks').val();
        Obj.IsEnsureDS = $('input[name=rdoEnsureDS]:checked').val();
        Obj.EnsureDSRemarks = $('#txtEnsureDSRemarks').val();
        Obj.IsSigned = $('input[name=rdoSigned]:checked').val();
        Obj.SignedRemarks = $('#txtSignedRemarks').val();
        Obj.IsRefferal = $('input[name=rdoRefferal]:checked').val();
        Obj.RefferalRemarks = $('#txtRefferalRemarks').val();
        Obj.IsVenflon = $('input[name=rdoVenflon]:checked').val();
        Obj.VenflonRemarks = $('#txtVenflonRemarks').val();
        Obj.IsWound = $('input[name=rdoWound]:checked').val();
        Obj.WoundRemarks = $('#txtWoundRemarks').val();
        Obj.IsDischrageLog = $('input[name=rdoDisLog]:checked').val();
        Obj.DischargeLogRemarks = $('#txtDisLogRemakrs').val();
        Obj.IsEnsureBilling = $('input[name=rdoEnsureBilling]:checked').val();
        Obj.EnsureBillingRemarks = $('#txtEnsureBillingRemarks').val();
        Obj.IsCheckout = $('input[name=rdoCheckout]:checked').val();
        Obj.CheckoutRemarks = $('#txtCheckoutRemarks').val();
        Obj.ID = $('#lblID').text();
        Obj.CreatedDate = $('#lblCreateDate').text();
        data.push(Obj);
        return data;
    }

    function UpdateRecord() {
        var resultData = getData();
        var TID = '<%=Request.QueryString["TransactionID"]%>';
        var PID = '<%=Request.QueryString["PatientId"]%>';
        serverCall('DischargeCheckList.aspx/UpdateCheckList', { Data: resultData, TID: TID, PID: PID }, function (response) {
            var result = parseInt(response);
            if (result == 1)
                modelAlert('Record Update Successfully');
            else
                modelAlert('Error Occured');
        });
    }

</script>

