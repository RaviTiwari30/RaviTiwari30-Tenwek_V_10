<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DeceasedPatientCheckList.aspx.cs" Inherits="Design_IPD_DeceasedPatientCheckList" %>

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
                <b>Deceased Patient CheckList</b>

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
                            <div class="col-md-3">
                                <label class="pull-left">UHID</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <label id="lblUHID" class="patientInfo"></label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    IPD No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <label id="lblIPDNo"  class="patientInfo"></label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Patient Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <label id="lblPname"  class="patientInfo"></label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Date Of Birth</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <label id="lblDOB" class="patientInfo"></label>
                            </div>
                            <div class="col-md-3" style="text-align:left;">
                                <label class="pull-left">
                                    Address
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <label id="lblAddress" class="patientInfo"></label>
                            </div>
                            <div class="col-md-3" style="text-align:left;">
                                <label class="pull-left">
                                    Religion
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <label id="lblReligion" class="patientInfo"></label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Date Of Death</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                               <asp:TextBox ID="txtDateDeath" runat="server" ClientIDMode="Static"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalDeath" runat="server" TargetControlID="txtDateDeath" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Time Of Death
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:TextBox ID="txtTimeDeath" runat="server" Width="90px" ClientIDMode="Static"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtTimeDeath"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtTimeDeath"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A-AM/P-PM)</span></em>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Next of Kin Informed
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <input type="radio" name="rdoKin" value="1" />Yes
                                <input type="radio" name="rdoKin" value="0" checked="checked" />No
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Contacted By</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtContactBy" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Time Contacted
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtTimeContact" runat="server" Width="90px"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtTimeContact"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlToValidate="txtTimeContact"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A-AM/P-PM)</span></em>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Date Contacted
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:TextBox ID="txtDateContact" runat="server" ClientIDMode="Static"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDateContact" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Patient’s Property Returned</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <input type="radio" name="rdoProperty" value="1" />Yes
                                <input type="radio" name="rdoProperty" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Dentures In Place         
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <input type="radio" name="rdoDenture" value="1" />Yes
                                <input type="radio" name="rdoDenture" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Jewellery In Place      
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <input type="radio" name="rdoJwel" value="1" />Yes
                                <input type="radio" name="rdoJwel"  value="0" checked="checked" />No
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Type of Jewellery</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtJwelType" />
                            </div>
                            <div class="col-md-11">
                                <label class="pull-left">
                                    Is there a wish by the relative of the deceased to see a religious leader
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <input type="radio" name="rdoWish" value="1" />Yes
                                <input type="radio" name="rdoWish" value="0" checked="checked" />No
                            </div>
                            
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Any other wishes</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtOtherWish" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Last office carried out by nurse
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <input type="radio" name="rdoOffice" value="1" />Yes
                                <input type="radio" name="rdoOffice" value="0" checked="checked" />No
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Read back by deceased’s next of kin and family
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <input type="radio" name="rdoReadBack" value="1" />Yes
                                <input type="radio" name="rdoReadBack" value="0" checked="checked" />No
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">comments</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-21">
                                <input type="text" id="txtComments" />
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
            <div class="POuter_Box_Inventory">
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
        serverCall('DeceasedPatientCheckList.aspx/BindPatientDetail', { TID: TID }, function (response) {
            StockData = jQuery.parseJSON(response);
            if (StockData.length != "0") {
                $('#lblUHID').text(StockData[0].PatientID);
                $('#lblIPDNo').text(StockData[0].IPDNO);
                $('#lblPname').text(StockData[0].Pname);
                $('#lblDOB').text(StockData[0].DOB);
                $('#lblAddress').text(StockData[0].address);
                $('#lblReligion').text(StockData[0].Religion);
                $('#txtDateDeath').val(StockData[0].DateofDeath).attr('disabled','disabled');
                $('#txtTimeDeath').val(StockData[0].TimeofDeath).attr('disabled', 'disabled');
                $('input[name="rdoKin"]').filter("[value='" + StockData[0].NextOfKinInformed + "']").attr('checked', true);
                $('input[name="rdoProperty"]').filter("[value='" + StockData[0].PropertyReturn + "']").attr('checked', true);
                $('input[name="rdoDenture"]').filter("[value='" + StockData[0].DentureinPlace + "']").attr('checked', true);
                $('input[name="rdoJwel"]').filter("[value='" + StockData[0].JewelleryinPlace + "']").attr('checked', true);
                $('input[name="rdowish"]').filter("[value='" + StockData[0].IsWishbyRelative + "']").attr('checked', true);
                $('input[name="rdoOffice"]').filter("[value='" + StockData[0].LastOffice + "']").attr('checked', true);
                $('input[name="rdoReadBack"]').filter("[value='" + StockData[0].ReadBackbyKin + "']").attr('checked', true);
                $('#txtContactBy').val(StockData[0].ContactBy);
                $('#txtTimeContact').val(StockData[0].TimeofContact);
                $('#txtDateContact').val(StockData[0].DateofContact);
                $('#txtJwelType').val(StockData[0].TypeOfJewellery);
                $('#txtOtherWish').val(StockData[0].AnyOtherWish);
                $('#txtComments').val(StockData[0].Comments)
                $('#lblCreateDate').text(StockData[0].CreateDate);
                $('#lblID').text(StockData[0].ID);
                if (StockData[0].ID != null && StockData[0].ID != "") {
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
        serverCall('DeceasedPatientCheckList.aspx/SaveCheckList', { Data: resultData, TID: TID, PID: PID }, function (response) {
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
          
        Obj.NextOfKinInformed = $('input[name=rdoKin]:checked').val();
        Obj.ContactBy=$('#txtContactBy').val();
        Obj.TimeofContact = $('#txtTimeContact').val();
        Obj.DateofContact = $('#txtDateContact').val(); 
        Obj.PropertyReturn = $('input[name=rdoProperty]:checked').val();
        Obj.DentureinPlace = $('input[name=rdoDenture]:checked').val();
        Obj.JewelleryinPlace = $('input[name=rdoJwel]:checked').val();
        Obj.TypeOfJewellery = $('#txtJwelType').val()
        Obj.IsWishbyRelative = $('input[name=rdowish]:checked').val();
        Obj.AnyOtherWish = $('#txtOtherWish').val()
        Obj.LastOffice = $('input[name=rdoOffice]:checked').val();
        Obj.ReadBackByKin = $('input[name=rdoReadBack]:checked').val();
        Obj.Comments = $('#txtComments').val();
        Obj.ID = $('#lblID').text();
        Obj.CreatedDate = $('#lblCreateDate').text();
        data.push(Obj);
        return data;
    }

    function UpdateRecord() {
        var resultData = getData();
        var TID = '<%=Request.QueryString["TransactionID"]%>';
        var PID = '<%=Request.QueryString["PatientId"]%>';
        serverCall('DeceasedPatientCheckList.aspx/UpdateCheckList', { Data: resultData, TID: TID, PID: PID }, function (response) {
            var result = parseInt(response);
            if (result == 1)
                modelAlert('Record Update Successfully');
            else
                modelAlert('Error Occured');
        });
    }

</script>

