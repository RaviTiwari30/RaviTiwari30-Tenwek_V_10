<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AssetWoGRN.aspx.cs" Inherits="Design_Equipment_Masters_AssetWoGRN" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="stylesheet" href="../../../Styles/PurchaseStyle.css" />
    <link href="../../../Styles/grid24.css" rel="stylesheet" type="text/css" />
    <style>
        .ItDoseDropdownbox
        {
            margin-top:0px;
        }
    </style>
</head>
<script type="text/javascript">
    $(document).ready(function () {
        $('#ucFromDate').change(function () {
            ChkDate();

        });

        $('#ucToDate').change(function () {
            ChkDate();

        });

    });

    function getDate() {

        $.asp({

            url: "~/Design/Common/CommonService.asmx/getDate",
            data: '{}',
            type: "POST",
            async: true,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var data = mydata.d;


                return;
            }
        });
    }

    function ChkDate() {

        $.asp({

            url: "~/Design/Common/CommonService.asmx/CompareDate",
            data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
            type: "POST",
            async: true,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var data = mydata.d;
                if (data == false) {
                    $('#lblMsg').text('To date can not be less than from date!');
                    getDate();

                }
                else {
                    $('#lblMsg').text('');
                    $('#btnView').removeAttr('disabled');
                }
            }
        });

    }
    function check(e) {
        var keynum
        var keychar
        var numcheck
        // For Internet Explorer  
        if (window.event) {
            keynum = e.keyCode
        }
            // For Netscape/Firefox/Opera  
        else if (e.which) {
            keynum = e.which
        }
        keychar = String.fromCharCode(keynum)

        //List of special characters you want to restrict
        if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
            return false;
        }

        else {
            return true;
        }
    }

</script>
<body style="margin-top: 1px; margin-left: 1px;">
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div id="Pbody_box_inventory" style="width: 100%;">
            <div class="POuter_Box_Inventory" style="width: 100%;">
                <asp:ScriptManager ID="smManager" runat="server">
                </asp:ScriptManager>
                <div style="text-align: center">
                    <b>Asset Master<br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </b>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="width: 100%;">
                <div class="Purchaseheader">
                    General Detail
                </div>
                <div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Asset Type </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlAssetType" runat="server" Width="90%" CssClass="ItDoseDropdownbox">
                                </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Asset Name </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtAssetName" runat="server" Width="180px" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Asset Code </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAssetCode" runat="server" Width="180px" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Serial No </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSerialNo" runat="server" Width="180px" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Model No </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtModelNo" runat="server" Width="180px" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Asset Tag No </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtTagNo" runat="server" Width="180px" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Supplier Type </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSupplierType" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlSupplierType_SelectedIndexChanged" Width="90%" CssClass="ItDoseDropdownbox">
                                </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Suppiler Name </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSupplier" runat="server" AutoPostBack="True" Width="90%" CssClass="ItDoseDropdownbox">
                                </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Make </label>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMake" runat="server" Width="180px" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Technical Detail (500 characters) </label>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTechnical" runat="server" Width="453px" Height="61px" TextMode="MultiLine" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="width: 100%;">
                <div class="Purchaseheader">
                    &nbsp;Warranty &amp; Installation Detail
                </div>
                <div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Purchase Date </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucPurDate" runat="server" ToolTip="Click To Select From Date" Width="180px" CssClass="ItDoseTextinputText" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                                <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucPurDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Installation Date </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucInstallationDate" runat="server" ToolTip="Click To Select From Date" Width="180px" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucInstallationDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Free Service From </label>
                            
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFreeServiceFrom" runat="server" ToolTip="Click To Select From Date" Width="180px" CssClass="ItDoseTextinputText" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                                <cc1:CalendarExtender ID="fc3" runat="server" TargetControlID="ucFreeServiceFrom" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Free Service To </label>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFreeServiceTo" runat="server" ToolTip="Click To Select From Date" Width="180px" CssClass="ItDoseTextinputText" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                                <cc1:CalendarExtender ID="fc4" runat="server" TargetControlID="ucFreeServiceTo" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Warranty From </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucWarrantyFrom" runat="server" ToolTip="Click To Select From Date" Width="180px" CssClass="ItDoseTextinputText" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                                <cc1:CalendarExtender ID="fc5" runat="server" TargetControlID="ucWarrantyFrom" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Warranty To </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucWarrantyTo" runat="server" ToolTip="Click To Select From Date" Width="180px" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                <cc1:CalendarExtender ID="fc6" runat="server" TargetControlID="ucWarrantyTo" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Warranty Terms &amp; Conditions (500 characters) </label>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtWarrantyCondition" runat="server" Width="453px" Height="61px" TextMode="MultiLine" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        
                        <div class="col-md-3">
                            <label class="pull-left">AMC Type  </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlAmcType" runat="server" AutoPostBack="True" Width="92%" CssClass="ItDoseDropdownbox">
                                </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Service Suppiler  </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="ddlSupplierService" runat="server" AutoPostBack="True" Width="92%" CssClass="ItDoseDropdownbox">
                                </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Service Date From  </label>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucServiceFrom" runat="server" ToolTip="Click To Select From Date" Width="180px" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                <cc1:CalendarExtender ID="fc7" runat="server" TargetControlID="ucServiceFrom" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                    </div>

                    <div class="row">
                        
                        <div class="col-md-3">
                            <label class="pull-left">Service Date To  </label>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="ucServiceTo" runat="server" ToolTip="Click To Select From Date" Width="180px" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                <cc1:CalendarExtender ID="fc8" runat="server" TargetControlID="ucServiceTo" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Last Service Date </label>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="ucLastServiceDate" runat="server" ToolTip="Click To Select From Date" Width="180px" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                <cc1:CalendarExtender ID="fc9" runat="server" TargetControlID="ucLastServiceDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Next Service Date </label>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="ucNextServiceDate" runat="server" ToolTip="Click To Select From Date" Width="180px" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                <cc1:CalendarExtender ID="fc10" runat="server" TargetControlID="ucNextServiceDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="width: 100%;">
                <div class="Purchaseheader">
                    &nbsp;Location Detail
                </div>
                <div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Floor  </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlFloor" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlFloor_SelectedIndexChanged" Width="92%" CssClass="ItDoseDropdownbox">
                                </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Location  </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlLocation" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlLocation_SelectedIndexChanged" Width="92%" CssClass="ItDoseDropdownbox">
                                </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Room  </label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlRoom" runat="server" Width="92%" CssClass="ItDoseDropdownbox">
                                </asp:DropDownList>
                        </div>
                    </div>

                    <div class="row" style="margin-bottom:10px;">
                        <div class="col-md-3">
                            <label class="pull-left">Assigned  To</label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAssignedTo" runat="server" Width="180px" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Assigned On</label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucAssignedOn" runat="server" ToolTip="Click To Select From Date" Width="180px" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                <cc1:CalendarExtender ID="fc11" runat="server" TargetControlID="ucAssignedOn" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Status</label>
                            <span class="ItDoseLblError">*</span>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="True" Width="92%" CssClass="ItDoseDropdownbox">
                                    <asp:ListItem Value="1" Text="ACTIVE" Selected="False"></asp:ListItem>
                                    <asp:ListItem Value="0" Text="DEACTIVE" Selected="False"></asp:ListItem>
                                </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="width: 100%;">
                    <div class="Purchaseheader">
                        &nbsp;Service Agreement
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Service Agreement</label>
                        </div>
                        <div class="col-md-5">
                             <asp:FileUpload ID="fileUpload1" runat="server" Width="400px" />
                        </div>
                    </div>
                 <%--   <table>
                        <tr>
                            <td style="width: 25%">Service Agreement&nbsp; <span class="ItDoseLblError"></span></td>
                            <td colspan="3">
                                <asp:FileUpload ID="fileUpload1" runat="server" Width="400px" />
                            </td>
                        </tr>
                    </table>--%>
                </div>
                <div class="POuter_Box_Inventory" style="width: 100%;">
                    <table style="width:100%;">
                        <tr>
                            <td style="width: 50%; text-align: right;">
                                <asp:Button ID="btnsave" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="btnsave_Click" />
                            </td>
                            <td style="width: 50%; text-align: left;">
                                <asp:Button ID="btnclear" runat="server" OnClick="btnclear_Click" Text="Clear" CssClass="ItDoseButton" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
