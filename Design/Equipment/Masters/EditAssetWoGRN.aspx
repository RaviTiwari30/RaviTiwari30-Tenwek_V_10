<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditAssetWoGRN.aspx.cs" Inherits="Design_Equipment_Masters_EditAssetWoGRN" %>

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
<script type="text/javascript" language="javascript">
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
<body style="margin-top: 1px; margin-left: 1px;overflow:hidden;">
    <form id="form1" runat="server" enctype="multipart/form-data">
        <asp:ScriptManager ID="smManager" runat="server">
        </asp:ScriptManager>
        <div id="Pbody_box_inventory" style="width: 100%;">
            <div class="content" style="text-align: center; width: 100%">
                <b>Edit Asset Master<br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </b>
            </div>
            <asp:Panel ID="Panel2" runat="server" Visible="true" HorizontalAlign="Center">
                <div class="POuter_Box_Inventory" style="width: 100%;">
                    <div class="Purchaseheader">
                        Search Criteria
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Asset Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlserchassettype" runat="server" Width="100%" CssClass="ItDoseDropdownbox">
                                </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">AssetName</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtsearchassetname" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">AssetCode </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtseatchAssetcode" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">SupplierName </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtsearchsuppliername" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center; width: 100%;">
                    <table style="width: 100%;">
                        <tr>
                            <td style="text-align: center;">
                                <asp:Button ID="btnsearch" runat="server" Text="Search" OnClick="btnsearch_Click" CssClass="ItDoseButton" />
                            </td>                            
                        </tr>
                    </table>
                </div>
                <div class="POuter_Box_Inventory" style="width: 100%;">
                    <div class="Purchaseheader">
                        Asset Detail
                    </div>
                    <div style="overflow: scroll; height: 350px; width: 100%;">
                        <asp:GridView ID="grdasset" runat="server" AutoGenerateColumns="false" CssClass="GridViewScrollHeaderStyle"
                            OnRowCommand="grdasset_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="Edit">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbEdit" ToolTip="Edit Supplier" runat="server" ImageUrl="~/Images/edit.png"
                                            CausesValidation="false" CommandArgument='<%# Eval("AssetID")%>' CommandName="EditAT" />
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="View Document">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbViewdoc" runat="server" CommandName="AView" ToolTip="View Approval"
                                            ImageAlign="middle" CausesValidation="false" ImageUrl="~/Images/view.GIF"
                                            CommandArgument='<%# Eval("AssetID")+"$"+Eval("AgreementFileName") %>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>

                                <%--   <asp:TemplateField>
                            <ItemTemplate>
                            <asp:Label ID="lblFileName" runat="server" Visible="true" Text='<%# Eval("AgreementFileName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>--%>

                                <%--<asp:TemplateField HeaderText="Log">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="~/Images/view.GIF" 
                                    CausesValidation="false" CommandArgument='<%# Eval("AssetID")%>' CommandName="ViewLog" />
                               
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                                <asp:TemplateField HeaderText="AssetName">
                                    <ItemTemplate>
                                        <%#Eval("AssetName")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="AssetCode">
                                    <ItemTemplate>
                                        <%#Eval("AssetCode")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="SerialNo">
                                    <ItemTemplate>
                                        <%#Eval("SerialNo")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ModelNo">
                                    <ItemTemplate>
                                        <%#Eval("ModelNo")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="TagNo">
                                    <ItemTemplate>
                                        <%#Eval("TagNo")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PurchaseDate">
                                    <ItemTemplate>
                                        <%#Eval("PurchaseDate")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="InstallationDate">
                                    <ItemTemplate>
                                        <%#Eval("InstallationDate")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="WarrantyFrom">
                                    <ItemTemplate>
                                        <%#Eval("WarrantyFrom")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="WarrantyTo">
                                    <ItemTemplate>
                                        <%#Eval("WarrantyTo")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="FreeServiceFrom">
                                    <ItemTemplate>
                                        <%#Eval("FreeServiceFrom")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="FreeServiceTo">
                                    <ItemTemplate>
                                        <%#Eval("FreeServiceTo")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="WarrantyTerms">
                                    <ItemTemplate>
                                        <%#Eval("WarrantyTerms")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ServiceDateFrom">
                                    <ItemTemplate>
                                        <%#Eval("ServiceDateFrom")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Active">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <%#Eval("IsActive") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="User">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <%# Eval("updateby")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Date">
                                    <ItemStyle CssClass="GridViewItemStyle" Wrap="false" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <%# Eval("UpdateDate") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="IPAddress">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <%# Eval("Ipnumber")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="Panel1" runat="server" Visible="False">
                <div class="POuter_Box_Inventory" style="width: 690px;">
                    <div class="Purchaseheader">
                        General Detail
                    </div>
                    <div>
                        <table>
                            <tr>
                                <td style="width: 25%">Asset Type <span class="ItDoseLblError">*</span></td>
                                <td style="width: 30%; text-align: left;">
                                    <asp:DropDownList ID="ddlAssetType" runat="server" Width="150px" CssClass="ItDoseDropdownbox">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%">Asset Name <span class="ItDoseLblError">*</span></td>
                                <td style="width: 30%">
                                    <asp:TextBox ID="txtAssetName" runat="server" Width="180px" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%">Asset Code <span class="ItDoseLblError">*</span></td>
                                <td style="width: 30%">
                                    <asp:TextBox ID="txtAssetCode" runat="server" Width="180px" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>
                                <td style="width: 25%">Serial No <span class="ItDoseLblError">*</span></td>

                                <td style="width: 30%">
                                    <asp:TextBox ID="txtSerialNo" runat="server" Width="180px" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%">Model No </td>
                                <td style="width: 30%">
                                    <asp:TextBox ID="txtModelNo" runat="server" Width="180px" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>
                                <td style="width: 25%">Asset Tag No</td>

                                <td style="width: 30%">
                                    <asp:TextBox ID="txtTagNo" runat="server" Width="180px" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%">Supplier Type <span class="ItDoseLblError">*</span></td>
                                <td style="width: 30%">
                                    <asp:DropDownList ID="ddlSupplierType" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlSupplierType_SelectedIndexChanged" Width="150px" CssClass="ItDoseDropdownbox">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%">Suppiler Name <span class="ItDoseLblError">*</span></td>

                                <td style="width: 30%">
                                    <asp:DropDownList ID="ddlSupplier" runat="server" AutoPostBack="True" Width="150px" CssClass="ItDoseDropdownbox">
                                    </asp:DropDownList>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%">Make</td>
                                <td style="width: 30%">
                                    <asp:TextBox ID="txtMake" runat="server" Width="180px" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>
                                <td style="width: 20%">&nbsp;MachineID</td>
                                <td style="width: 30%">&nbsp;<asp:Label ID="lblMachineid" runat="server"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 25%">Technical Detail (500 characters)</td>
                                <td colspan="3" style="width: 20%">
                                    <asp:TextBox ID="txtTechnical" runat="server" Width="453px" Height="61px" TextMode="MultiLine" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="width: 690px;">
                    <div class="Purchaseheader">
                        &nbsp;Warranty &amp; Installation Detail
                    </div>
                    <div>
                        <table>
                            <tr>
                                <td style="width: 25%">Purchase Date <span class="ItDoseLblError">*</span></td>
                                <td style="width: 30%">
                                    <asp:TextBox ID="ucPurDate" runat="server" ToolTip="Click To Select From Date" Width="180px" CssClass="ItDoseTextinputText" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucPurDate" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>

                                </td>
                                <td style="width: 25%">Installation Date <span class="ItDoseLblError">*</span></td>
                                <td style="width: 30%">
                                    <asp:TextBox ID="ucInstallationDate" runat="server" ToolTip="Click To Select From Date" Width="180px" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucInstallationDate" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%">Free Service From</td>
                                <td style="width: 30%">
                                    <asp:TextBox ID="ucFreeServiceFrom" runat="server" ToolTip="Click To Select From Date" Width="180px" CssClass="ItDoseTextinputText" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc3" runat="server" TargetControlID="ucFreeServiceFrom" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>
                                </td>
                                <td style="width: 25%">Free Service To</td>
                                <td style="width: 30%">
                                    <asp:TextBox ID="ucFreeServiceTo" runat="server" ToolTip="Click To Select From Date" Width="180px" CssClass="ItDoseTextinputText" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc4" runat="server" TargetControlID="ucFreeServiceTo" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%">Warranty From <span class="ItDoseLblError">*</span></td>
                                <td style="width: 30%">
                                    <asp:TextBox ID="ucWarrantyFrom" runat="server" ToolTip="Click To Select From Date" Width="180px" CssClass="ItDoseTextinputText" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc5" runat="server" TargetControlID="ucWarrantyFrom" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>
                                </td>
                                <td style="width: 25%">Warranty To <span class="ItDoseLblError">*</span></td>
                                <td style="width: 30%">
                                    <asp:TextBox ID="ucWarrantyTo" runat="server" ToolTip="Click To Select From Date" Width="180px" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc6" runat="server" TargetControlID="ucWarrantyTo" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%">Warranty Terms &amp; Conditions (500 characters)</td>
                                <td colspan="3" style="width: 20%">
                                    <asp:TextBox ID="txtWarrantyCondition" runat="server" Width="453px" Height="61px" TextMode="MultiLine" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%">AMC Type  <span class="ItDoseLblError">*</span></td>
                                <td style="width: 30%">
                                    <asp:DropDownList ID="ddlAmcType" runat="server" AutoPostBack="True" Width="150px" CssClass="ItDoseDropdownbox">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%">Service Suppiler<span class="ItDoseLblError"> *</span></td>
                                <td style="width: 30%">
                                    <asp:DropDownList ID="ddlSupplierService" runat="server" AutoPostBack="True" Width="150px" CssClass="ItDoseDropdownbox">
                                    </asp:DropDownList>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%">Service Date From</td>
                                <td style="width: 30%">
                                    <asp:TextBox ID="ucServiceFrom" runat="server" ToolTip="Click To Select From Date" Width="180px" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc7" runat="server" TargetControlID="ucServiceFrom" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>
                                </td>
                                <td style="width: 25%">Service Date To</td>

                                <td style="width: 30%">
                                    <asp:TextBox ID="ucServiceTo" runat="server" ToolTip="Click To Select From Date" Width="180px" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc8" runat="server" TargetControlID="ucServiceTo" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%">Last Service Date</td>
                                <td style="width: 30%">
                                    <asp:TextBox ID="ucLastServiceDate" runat="server" ToolTip="Click To Select From Date" Width="180px" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc9" runat="server" TargetControlID="ucLastServiceDate" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>
                                </td>
                                <td style="width: 25%">Next Service Date</td>
                                <td style="width: 30%">
                                    <asp:TextBox ID="ucNextServiceDate" runat="server" ToolTip="Click To Select From Date" Width="180px" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc10" runat="server" TargetControlID="ucNextServiceDate" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%">&nbsp;</td>
                                <td style="width: 30%">&nbsp;</td>
                                <td style="width: 25%"></td>
                                <td style="width: 30%"></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="width: 690px;">
                    <div class="Purchaseheader">
                        &nbsp;Location Detail
                    </div>
                    <div>
                        <table>
                            <tr>
                                <td style="width: 25%">Floor&nbsp; <span class="ItDoseLblError">*</span></td>
                                <td style="width: 30%">
                                    <asp:DropDownList ID="ddlFloor" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlFloor_SelectedIndexChanged" Width="150px" CssClass="ItDoseDropdownbox">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%;">Location&nbsp; <span class="ItDoseLblError">*</span></td>
                                <td style="width: 30%;">
                                    <asp:DropDownList ID="ddlLocation" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlLocation_SelectedIndexChanged" Width="150px" CssClass="ItDoseDropdownbox">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%;">Room&nbsp; <span class="ItDoseLblError">*</span></td>
                                <td style="width: 30%;">
                                    <asp:DropDownList ID="ddlRoom" runat="server" Width="150px" CssClass="ItDoseDropdownbox">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%;">Assigned To&nbsp; <span class="ItDoseLblError">*</span></td>
                                <td style="width: 30%;">
                                    <asp:TextBox ID="txtAssignedTo" runat="server" Width="180px" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%">Assigned On&nbsp;&nbsp; <span class="ItDoseLblError">*</span></td>
                                <td style="width: 30%">
                                    <asp:TextBox ID="ucAssignedOn" runat="server" ToolTip="Click To Select From Date" Width="180px" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc11" runat="server" TargetControlID="ucAssignedOn" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>
                                </td>
                                <td style="width: 25%">Status</td>
                                <td style="width: 30%">
                                    <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="True" Width="150px" CssClass="ItDoseDropdownbox">
                                        <asp:ListItem Value="1" Text="ACTIVE" Selected="False"></asp:ListItem>
                                        <asp:ListItem Value="0" Text="DEACTIVE" Selected="False"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%">&nbsp;</td>
                                <td style="width: 30%">&nbsp;</td>
                                <td style="width: 25%">&nbsp;</td>
                                <td style="width: 30%">&nbsp;</td>
                            </tr>
                        </table>
                    </div>
                    <div class="POuter_Box_Inventory" style="width: 690px;">
                        <div class="Purchaseheader">
                            &nbsp;Service Agreement
                        </div>
                        <table>
                            <tr>
                                <td style="width: 25%">Service Agreement&nbsp; <span class="ItDoseLblError">*</span></td>
                                <td>
                                    <asp:FileUpload ID="fileUpload1" runat="server" Width="400px" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="POuter_Box_Inventory" style="width: 690px;">
                        <table style="width: 100%">
                            <tr>
                                <td style="width: 52%; text-align: right;">
                                    <asp:Button ID="btnsave" runat="server" Text="UPDATE" CssClass="ItDoseButton" OnClick="btnsave_Click" />
                                </td>
                                <td style="width: 48%; text-align: left;">
                                    <asp:Button ID="btnclear" runat="server" OnClick="btnclear_Click" Text="Cancel" CssClass="ItDoseButton" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
