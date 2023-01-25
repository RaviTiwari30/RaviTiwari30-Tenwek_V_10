<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ComplainRegister.aspx.cs" Inherits="Design_Equipment_Masters_EditAssetWoGRN" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="stylesheet" href="../../../Styles/PurchaseStyle.css" />
    <style type="text/css">
        
        .ItDoseLblError
        {
            color: #FF0000;
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
<body style="margin-top: 1px; margin-left: 1px;">
    <form id="form1" runat="server" enctype="multipart/form-data">
        <asp:ScriptManager ID="smManager" runat="server">
        </asp:ScriptManager>
        <div id="Pbody_box_inventory" style="width: 700px;">
            <div class="POuter_Box_Inventory" style="text-align: center; width: 695px;">
                <b>Complaint Register<br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </b>
            </div>
            <%--<asp:Panel ID="Panel2" runat="server" Visible="true" HorizontalAlign="Center">
         <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
             Search Criteria
            </div>
            
            <table>
            <tr><td >Asset Type <span class="ItDoseLblError"></span></td>
                        <td >
                            <asp:DropDownList ID="ddlserchassettype" runat="server" Width="150px" Height="18px">
                            </asp:DropDownList>
                        </td>
            <td>
            AssetName
            </td><td><asp:TextBox ID="txtsearchassetname" runat="server" ></asp:TextBox></td>
            <td>AssetCode</td><td><asp:TextBox ID="txtseatchAssetcode" runat="server"></asp:TextBox></td>
            <td>SupplierName</td>
            <td><asp:TextBox ID="txtsearchsuppliername" runat="server" ></asp:TextBox></td>
            <td><asp:Button ID="btnsearch" runat="server" Text="Search" 
                    onclick="btnsearch_Click" /></td>
            </tr>
            </table>
           </div >

           </asp:Panel>--%>

            <div class="POuter_Box_Inventory" id="DivGrid" runat="server" style="width: 695px;">
                <%--<div id="divtop" runat="server"  class="content" style="overflow: scroll; height: 250px;">--%>
                <div id="divtop" runat="server" style="height: 500px; width: 695px; overflow: scroll;">
                    <asp:GridView ID="grdasset" runat="server" AutoGenerateColumns="false" CssClass="GridViewScrollHeaderStyle"
                        OnRowCommand="grdasset_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="Select">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" ToolTip="Edit Supplier" runat="server" ImageUrl="~/Images/edit.png"
                                        CausesValidation="false" CommandArgument='<%# Eval("AssetID")+"#"+Eval("TICKETID") %>' CommandName="EditAT" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="TICKET No">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <%#Eval("TICKETID")%>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <%--  <asp:TemplateField HeaderText="View Document">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbViewdoc" runat="server" CommandName="AView" ToolTip="View Approval"
                                    ImageAlign="middle" CausesValidation="false" ImageUrl="../../Purchase/Image/view.gif"
                                    CommandArgument='<%# Eval("AssetID")+"$"+Eval("AgreementFileName") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>--%>

                            <%--   <asp:TemplateField>
                            <ItemTemplate>
                            <asp:Label ID="lblFileName" runat="server" Visible="true" Text='<%# Eval("AgreementFileName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>--%>

                            <%-- <asp:TemplateField HeaderText="Log">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="../../Purchase/Image/view.gif" 
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
            <asp:Panel ID="Panel1" runat="server" Visible="False">
                <div class="POuter_Box_Inventory" style="width: 695px;">
                    <div class="Purchaseheader">
                        General Detail
                    </div>
                    <div>
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 25%;">Asset Type <span class="ItDoseLblError">*</span></td>
                                <td style="width: 25%;">
                                    <asp:DropDownList ID="ddlAssetType" runat="server" Width="153px" Enabled="false">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%">Asset Name <span class="ItDoseLblError">*</span></td>
                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtAssetName" runat="server" Width="150px" Enabled="false" CssClass="ItDoseTextinputText"></asp:TextBox><br />
                                    <asp:Label ID="lblAssetID" runat="server" Width="150px" Visible="false"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%;">Asset Code <span class="ItDoseLblError">*</span></td>
                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtAssetCode" runat="server" Width="150px" Enabled="false" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>
                                <td style="width: 25%;">Serial No <span class="ItDoseLblError">*</span></td>

                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtSerialNo" runat="server" Width="150px" Enabled="false" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%;">Model No </td>
                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtModelNo" runat="server" Width="150px" Enabled="false" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>
                                <td style="width: 25%;">Asset Tag No</td>

                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtTagNo" runat="server" Width="150px" Enabled="false" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%;">Supplier Type <span class="ItDoseLblError">*</span></td>
                                <td style="width: 25%;">
                                    <asp:DropDownList ID="ddlSupplierType" runat="server" AutoPostBack="True" Enabled="false"
                                        Width="153px" OnSelectedIndexChanged="ddlSupplierType_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%;">Suppiler Name <span class="ItDoseLblError">*</span></td>
                                <td style="width: 25%;">
                                    <asp:DropDownList ID="ddlSupplier" runat="server" AutoPostBack="True" Enabled="false" Width="153px">
                                    </asp:DropDownList>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%;">Make</td>
                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtMake" runat="server" Width="150px" Enabled="false" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>
                                <td style="width: 25%;">MachineID</td>
                                <td style="width: 25%;">&nbsp;<asp:Label ID="lblMachineid" runat="server"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 25%;">Technical Detail (500 characters)</td>
                                <td colspan="3" style="width: 75%;">
                                    <asp:TextBox ID="txtTechnical" runat="server" Width="453px" Height="61px" TextMode="MultiLine" Enabled="false" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="width: 695px;">
                    <div class="Purchaseheader">
                        Warranty &amp; Installation Detail
                    </div>
                    <div>
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 25%">Purchase Date <span class="ItDoseLblError">*</span></td>
                                <td style="width: 25%">
                                    <asp:TextBox ID="ucPurDate" runat="server" ToolTip="Click To Select From Date" Width="150px" ReadOnly="true"
                                        ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <%--<cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucPurDate" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>--%>
                                </td>
                                <td style="width: 25%">Installation Date <span class="ItDoseLblError">*</span></td>
                                <td style="width: 25%">
                                    <asp:TextBox ID="ucInstallationDate" runat="server" ToolTip="Click To Select From Date" Width="150px" ReadOnly="true"
                                        ClientIDMode="Static" TabIndex="5" Enabled="false" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <%--<cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucInstallationDate" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>--%>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%">Free Service From</td>
                                <td style="width: 25%">

                                    <asp:TextBox ID="ucFreeServiceFrom" runat="server" ToolTip="Click To Select From Date" Width="150px" ReadOnly="true"
                                        ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <%--<cc1:CalendarExtender ID="fc3" runat="server" TargetControlID="ucFreeServiceFrom" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>--%>
                                </td>
                                <td style="width: 25%">Free Service To</td>

                                <td style="width: 25%">
                                    <asp:TextBox ID="ucFreeServiceTo" runat="server" ToolTip="Click To Select From Date" Width="150px" ReadOnly="true"
                                        ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <%--<cc1:CalendarExtender ID="fc4" runat="server" TargetControlID="ucFreeServiceTo" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>--%>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%">Warranty From <span class="ItDoseLblError">*</span></td>
                                <td style="width: 25%">

                                    <asp:TextBox ID="ucWarrantyFrom" runat="server" ToolTip="Click To Select From Date" Width="150px" ReadOnly="true"
                                        ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <%--<cc1:CalendarExtender ID="fc5" runat="server" TargetControlID="ucWarrantyFrom" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>--%>
                                </td>
                                <td style="width: 25%">Warranty To <span class="ItDoseLblError">*</span></td>

                                <td style="width: 25%">
                                    <asp:TextBox ID="ucWarrantyTo" runat="server" ToolTip="Click To Select From Date" Width="150px" ReadOnly="true"
                                        ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <%--<cc1:CalendarExtender ID="fc6" runat="server" TargetControlID="ucWarrantyTo" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>--%>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%">Warranty Terms &amp; Conditions (500 characters)</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtWarrantyCondition" runat="server" Width="453px" Height="61px" TextMode="MultiLine" ReadOnly="true" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%">AMC Type</td>
                                <td style="width: 25%">
                                    <asp:DropDownList ID="ddlAmcType" runat="server" AutoPostBack="True" Enabled="false" Width="153px">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%">Service Suppiler Name</td>

                                <td style="width: 25%">
                                    <asp:DropDownList ID="ddlSupplierService" runat="server" AutoPostBack="True" Enabled="false" Width="153px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%">Service Date From</td>
                                <td style="width: 25%">
                                    <asp:TextBox ID="ucServiceFrom" runat="server" ToolTip="Click To Select From Date" ReadOnly="true"
                                        ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText" Width="150px"></asp:TextBox>
                                    <%--<cc1:CalendarExtender ID="fc7" runat="server" TargetControlID="ucServiceFrom" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>--%>
                                </td>
                                <td style="width: 25%">Service Date To</td>
                                <td style="width: 25%">
                                    <asp:TextBox ID="ucServiceTo" runat="server" ToolTip="Click To Select From Date" Width="150px" Enabled="false"
                                        ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <%--<cc1:CalendarExtender ID="fc8" runat="server" TargetControlID="ucServiceTo" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>--%>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%">Last Service Date</td>
                                <td style="width: 25%">

                                    <asp:TextBox ID="ucLastServiceDate" runat="server" ToolTip="Click To Select From Date" Width="150px" Enabled="false"
                                        ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <%--<cc1:CalendarExtender ID="fc9" runat="server" TargetControlID="ucLastServiceDate" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>--%>
                                </td>
                                <td style="width: 25%">Next Service Date</td>
                                <td style="width: 25%">
                                    <asp:TextBox ID="ucNextServiceDate" runat="server" ToolTip="Click To Select From Date" Width="150px" Enabled="false"
                                        ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <%--<cc1:CalendarExtender ID="fc10" runat="server" TargetControlID="ucNextServiceDate" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>--%>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%">&nbsp;</td>
                                <td style="width: 25%">&nbsp;</td>
                                <td style="width: 25%"></td>
                                <td style="width: 25%"></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="width: 695px;">
                    <div class="Purchaseheader">
                        &nbsp;Location Detail
                    </div>
                    <div>
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 25%;">Floor&nbsp; <span class="ItDoseLblError">*</span></td>
                                <td style="width: 25%;">
                                    <asp:DropDownList Enabled="false" ID="ddlFloor" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlFloor_SelectedIndexChanged" Height="16px" Width="153px">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%;">Location&nbsp; <span class="ItDoseLblError">*</span></td>
                                <td style="width: 25%;">
                                    <asp:DropDownList ID="ddlLocation" runat="server" AutoPostBack="True" Enabled="false" OnSelectedIndexChanged="ddlLocation_SelectedIndexChanged" Width="153px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%;">Room&nbsp; <span class="ItDoseLblError">*</span></td>
                                <td style="width: 25%;">
                                    <asp:DropDownList ID="ddlRoom" runat="server" Enabled="false" Width="153px">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%;">Assigned To&nbsp; <span class="ItDoseLblError">*</span></td>
                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtAssignedTo" runat="server" Width="150px" ReadOnly="true" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 25%;">Assigned On&nbsp;&nbsp; <span class="ItDoseLblError">*</span></td>
                                <td style="width: 25%;">
                                    <asp:TextBox ID="ucAssignedOn" runat="server" ToolTip="Click To Select From Date" Width="150px" ReadOnly="true"
                                        ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <%--<cc1:CalendarExtender ID="fc11" runat="server" TargetControlID="ucAssignedOn" Format="dd-MMM-yyyy" Animated="true">
                                    </cc1:CalendarExtender>--%>
                                </td>
                                <td style="width: 25%;">Active/InActive</td>
                                <td style="width: 25%;">
                                    <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="True" Enabled="false" Width="153px">
                                        <asp:ListItem Value="1" Text="ACTIVE" Selected="False"></asp:ListItem>
                                        <asp:ListItem Value="0" Text="DEACTIVE" Selected="False"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%;">&nbsp;</td>
                                <td style="width: 25%;">&nbsp;</td>
                                <td style="width: 25%;">&nbsp;</td>
                                <td style="width: 25%;">&nbsp;</td>
                            </tr>
                        </table>
                    </div>
                </div>
                <%--    <div class="POuter_Box_Inventory" style="width: 695px;">
                    <div class="Purchaseheader">
                        &nbsp;
                    </div>
                    <table>
                       <tr>
                        <td style="width: 20%">Service Agreement&nbsp; <span class="ItDoseLblError">*</span></td>
                        <td>
                                                <asp:FileUpload ID="fileUpload1" runat="server" Width="494px" /> 
                        </td>



                    </tr>
                    </table>
                </div>--%>
                <div class="POuter_Box_Inventory" style="width: 695px;">
                    <div class="Purchaseheader">
                        &nbsp;
                    </div>
                    <table>
                        <%-- <TABLE width="70%">--%>
                        <tbody>
                            <tr>
                                <td style="width: 25%;">Ticket No.: <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:Label ID="lblticketid" runat="server" Font-Size="Small"></asp:Label>
                                </td>
                                <td style="width: 25%;">Status: <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:Label ID="lblstatus1" runat="server" Font-Size="Small"></asp:Label>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 25%;">Name:&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:Label ID="lblname" runat="server" Font-Size="Small"></asp:Label>
                                </td>
                                <td style="width: 25%;">Department:&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:Label ID="lbldept" runat="server"></asp:Label>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 25%;">Priority: <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:Label ID="lblpriority" runat="server" Font-Size="Small"></asp:Label>
                                </td>
                                <td style="width: 25%;">Floor: <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:Label ID="lblfloor" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%;">ProblemStartTime:&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:Label ID="lblProblemStartTime" runat="server" Font-Size="Small"></asp:Label>
                                </td>
                                <td style="width: 25%;"><span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:Label ID="lblclosed" runat="server" Visible="false" Width="56px"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%;">Reporting Time: <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:Label ID="lbldate" runat="server" Font-Size="Small"></asp:Label>
                                </td>
                                <td style="width: 25%;">&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;"></td>
                            </tr>
                            <tr>
                                <td style="width: 25%;">Errortype: <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:Label ID="lblerrortype" runat="server" Font-Size="Small"></asp:Label>
                                </td>
                                <td style="width: 25%;"><span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;"></td>
                            </tr>
                            <tr>
                                <td style="width: 25%;">Attachment: <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:LinkButton ID="lnkbtnattachment" runat="server" Text="open" CommandName="open" OnClick="lnkbtnattachment_Click"></asp:LinkButton>
                                    <asp:Label Visible="False" ID="lblattachment" runat="server" Font-Size="Small" Font-Bold="False"></asp:Label>
                                </td>
                                <td style="width: 25%;"><span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;"></td>
                            </tr>
                            <tr>
                                <td style="width: 25%;">Status: <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:DropDownList ID="ddlaction" runat="server" Enabled="false">
                                        <asp:ListItem Value="0">Open</asp:ListItem>
                                        <asp:ListItem Value="1">Process</asp:ListItem>
                                        <asp:ListItem Value="2">Close</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%;">&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;"></td>
                            </tr>

                            <tr>
                                <td style="width: 25%;">&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <div id="StatusClose" style="display: none">
                                        <asp:TextBox ID="txtCloseTime" runat="server" Width="80px" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    </div>
                                </td>
                                <td style="width: 25%;">
                                    <cc1:MaskedEditExtender ID="mee_txtFromTime" runat="server" AcceptAMPM="true" AcceptNegative="None"
                                        Mask="99:99:99" MaskType="Time" TargetControlID="txtCloseTime">
                                    </cc1:MaskedEditExtender>
                                    &nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;"></td>
                            </tr>
                            <tr>
                                <td style="width: 25%;">&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:DropDownList ID="ddlPriority" runat="server" Width="156px" Visible="false">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%;">
                                    <asp:Button ID="btnUpdate" OnClick="btnupdate_Click" runat="server" Text="Update" Visible="false" CssClass="ItDoseButton"></asp:Button>
                                    &nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;"></td>
                            </tr>


                            <tr>
                                <td style="width: 25%;">&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;"></td>
                                <td style="width: 25%;">&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;"></td>
                            </tr>

                            <tr>
                                <td style="width: 25%;">Description:&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:Label ID="lbldescription" runat="server" Font-Size="Small"></asp:Label>
                                </td>
                                <td style="width: 25%;">&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;"></td>
                            </tr>

                            <tr>
                                <td style="width: 25%;">Informed By:&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtInformedBy" runat="server" ReadOnly="true" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <asp:Label ID="lblInformedByID" runat="server" Font-Size="Small" Visible="false"></asp:Label>
                                </td>
                                <td style="width: 25%;">Solved By:
                         &nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:DropDownList ID="ddlSolvedBy" runat="server"></asp:DropDownList>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 25%;">Solve(Inhouse/OutSource):&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:DropDownList ID="ddlSolve" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSolve_SelectedIndexChanged">
                                        <asp:ListItem Value="Select" Text="Select" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="InHouse" Text="InHouse"></asp:ListItem>
                                        <asp:ListItem Value="OutSource" Text="OutSource"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%;">&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;"></td>
                            </tr>


                            <tr id="trOutSource" runat="server" visible="false">
                                <td style="width: 25%;">Company Details:&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtCompDetails" runat="server" TextMode="MultiLine" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>
                                <td style="width: 25%;">Person Details:
                         &nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtpersonDetail" runat="server" TextMode="MultiLine" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>
                            </tr>

                            <tr id="trOutSource2" runat="server" visible="false">
                                <td style="width: 25%;">Amount:&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtamt" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="fltAmt" runat="server" FilterType="Numbers" TargetControlID="txtamt"></cc1:FilteredTextBoxExtender>
                                </td>
                                <td style="width: 25%;">Bill:
                         &nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:FileUpload ID="fldBill" runat="server" Width="250px" />
                                    <asp:LinkButton ID="lnkBill" runat="server" Text="open" CommandName="open" OnClick="lnkBill_Click"></asp:LinkButton>
                                    <asp:Label ID="lblBillAttachment" runat="server" Visible="false"></asp:Label>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 25%;">Work Details:&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtwrkDetails" runat="server" TextMode="MultiLine" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>
                                <td style="width: 25%;">&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;"></td>
                            </tr>

                            <tr>
                                <td style="width: 25%;">Part Changed:&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:DropDownList ID="ddlPartChange" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlPartChange_SelectedIndexChanged">
                                        <asp:ListItem Value="YES" Text="YES"></asp:ListItem>
                                        <asp:ListItem Value="NO" Text="NO" Selected="True"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%;">
                                    <div id="divPartDetail" runat="server" visible="false">Part Details:</div>
                                    &nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtPartDetails" Visible="false" runat="server" TextMode="MultiLine" CssClass="ItDoseTextinputText"></asp:TextBox>
                                </td>
                            </tr>

                            <tr id="trPart2" runat="server" visible="false">
                                <td style="width: 25%;">Cost:&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtCost" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="fltCost" runat="server" FilterType="Numbers" TargetControlID="txtCost"></cc1:FilteredTextBoxExtender>
                                </td>
                                <td style="width: 25%;">Image:
                         &nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:FileUpload ID="fldPartImage" runat="server" Width="250px" />
                                    <asp:LinkButton ID="lnkPartImage" runat="server" Text="open" CommandName="open" OnClick="lnkPartImage_Click"></asp:LinkButton>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 25%;">Comment:&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;">
                                    <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" CssClass="ItDoseTextinputText"></asp:TextBox><asp:Label ID="lblImageAttachment" runat="server" Visible="false"></asp:Label>
                                </td>
                                <td style="width: 25%;">&nbsp; <span class="ItDoseLblError"></span></td>
                                <td style="width: 25%;"></td>
                            </tr>



                            <%-- </table>
    </div>--%><%--<div style="margin-top:10px ; margin-left:15px; margin-right:16px">
    <table>--%><%--</table>
    </div>--%>
                            <%-- <div style="margin-top:10px ; margin-left:15px; margin-right:16px;">
    <table>--%>
                            <tr>
                                <td colspan="4"></td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <asp:Repeater ID="rpReply" runat="server">
                                        <ItemTemplate>
                                            <table width="90%">
                                                <tr>
                                                    <span style="font-weight: bold; font-size: 12px">Reply: &nbsp <%#Eval("Name")%>&nbsp&nbsp&nbsp<%#Eval("REPLY_TIME") %></span></tr>
                                                <tr>
                                                    <td style="width: 100%">
                                                        <asp:Label Text='<%#Eval("DESCRIPTION")%>' runat="server" Mode="Transform" ID="lblDescription"></asp:Label>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <hr align="left" width="100%">
                                                    </td>
                                                </tr>
                                            </table>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </td>
                            </tr>
                            <%--  <tr>
         <td style="width: 130px">
             <asp:Label id="lblSolvedBy" runat="server" Text="Solved By:" Visible="false" ></asp:Label>    
             </td>
             
             <td >
                 <asp:DropDownList ID="ddlSolvedBy" runat="server" ></asp:DropDownList></td>
         </tr>--%>
                            <tr>
                                <td style="width: 130px">
                                    <asp:Label ID="lblProcess" runat="server" Text="Process By:"></asp:Label>
                                </td>

                                <td>
                                    <asp:DropDownList ID="ddlProcessBy" runat="server"></asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td style="width: 130px">
                                    <asp:Label ID="lbl1" runat="server" Text="Closed By:" Visible="false"></asp:Label>
                                </td>

                                <td>
                                    <asp:Label ID="lblClose" runat="server"></asp:Label></td>
                            </tr>

                            <tr>
                                <td style="width: 130px"></td>
                                <td></td>
                            </tr>

                            <tr>
                                <td colspan="4">
                                    <asp:Label ID="lblResponse" runat="server" Text="Canned Response:" Visible="false"></asp:Label>
                                    <asp:DropDownList ID="ddlreplyrspnce" runat="server" OnSelectedIndexChanged="ddlreplyrspnce_SelectedIndexChanged" AutoPostBack="True" Visible="false">
                                    </asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <asp:TextBox ID="txtDecription" align="left" runat="server" TextMode="MultiLine" Columns="45" Rows="10" CssClass="ItDoseTextinputText"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <asp:Button align="left" ID="btnReply" runat="server" Text="Reply" OnClick="btnReply_Click" CssClass="ItDoseButton" /></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="POuter_Box_Inventory" style="width: 695px;">
                    <table style="width: 100%">
                        <tr>
                            <td style="width: 52%; text-align: right;">
                                <asp:Button ID="btnsave" Visible="false" runat="server" Text="UPDATE" CssClass="ItDoseButton" OnClientClick="RestrictDoubleEntry(this);" />
                            </td>
                            <td style="width: 48%; text-align: left;">
                                <asp:Button ID="btnclear" runat="server" OnClick="btnclear_Click" Text="Cancel" Visible="false" CssClass="ItDoseButton" />
                            </td>
                        </tr>
                    </table>

                </div>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
