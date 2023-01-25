<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="ChangeLocation.aspx.cs"
    Inherits="Design_Equipment_Masters_ChangeLocation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<script type="text/javascript" language="javascript">

    function clickBTNADD(LoctaionID, LoctaionType, AssetID, AssetName, AssetCode) {
        window.opener.aspnetForm.document.getElementById("ctl00_ContentPlaceHolder1_lblLocationType").value = LoctaionType;
        window.opener.aspnetForm.document.getElementById("ctl00_ContentPlaceHolder1_lblAssetID").value = AssetID;
        window.opener.aspnetForm.document.getElementById("ctl00_ContentPlaceHolder1_lblAssetName").value = AssetName;
        window.opener.aspnetForm.document.getElementById("ctl00_ContentPlaceHolder1_lblAssetCode").value = AssetCode;

        this.focus();
        self.opener = this;
        self.close();

    }
</script>
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
<body runat="server" enctype="multipart/form-data" style="overflow:hidden;">
    <form id="form1" runat="server" enctype="multipart/form-data">
        <asp:ScriptManager ID="smManager" runat="server">
        </asp:ScriptManager>
        <div id="Pbody_box_inventory" style="width: 100%;">
            <div class="POuter_Box_Inventory" style="text-align: center; width: 100%;">
                <b>Change Location<br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </b>
            </div>
            <asp:Panel ID="Panel2" runat="server" Visible="true">
                <div class="POuter_Box_Inventory" style="width: 100%;">
                    <div class="Purchaseheader">
                        Search Criteria
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Location Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlLocationType" runat="server" CssClass="ItDoseDropdownbox" Width="100%">
                                </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Asset Type</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                           <asp:DropDownList ID="ddlserchassettype" runat="server" CssClass="ItDoseDropdownbox" Width="100%">
                                </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">AssetName</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtsearchassetname" runat="server" CssClass="ItDoseTextinputText" Width="100%"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">AssetCode</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtseatchAssetcode" runat="server" Width="100%"></asp:TextBox>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">SupplierName</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtsearchsuppliername" runat="server" Width="100%"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center; width: 1031px;">
                    <table style="width: 100%;">
                        <tr>
                            <td style="text-align: center;">
                                <asp:Button ID="Button1" runat="server" Text="Search" OnClick="btnsearch_Click" CssClass="ItDoseButton" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="POuter_Box_Inventory" style="width: 100%;">
                    <div class="Purchaseheader">
                        Asset Detail
                    </div>
                    <div style="overflow: scroll; height: 330px; width: 100%;">
                        <asp:GridView ID="grdasset" runat="server" AutoGenerateColumns="false" CssClass="GridViewScrollHeaderStyle"
                            OnRowCommand="grdasset_RowCommand" OnRowDataBound="grdasset_RowDataBound" OnSelectedIndexChanged="grdasset_SelectedIndexChanged">
                            <Columns>
                                <asp:TemplateField HeaderText="Edit" ShowHeader="false">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbEdit" ToolTip="Edit Supplier" runat="server" ImageUrl="~/Images/edit.png"
                                            CausesValidation="false" CommandArgument='<%# Eval("AssetID")%>' CommandName="EditAT" />
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="History" ShowHeader="false">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbHistory" ToolTip="Show History" runat="server" ImageUrl="~/Images/view.GIF"
                                            CausesValidation="false" CommandArgument='<%# Eval("AssetID")%>' CommandName="ShowHistory" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <%--<asp:TemplateField HeaderText="Log" ShowHeader="false">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="~/Images/view.GIF"
                                            CausesValidation="false" CommandArgument='<%# Eval("AssetID")%>' CommandName="ViewLog" />
                                    </ItemTemplate>
                                </asp:TemplateField>--%>

                                <%--<asp:CommandField ShowHeader="false" ShowSelectButton="True" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />--%>


                                <%-- <asp:TemplateField HeaderText="Select">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbSelect" ToolTip="Select" runat="server" ImageUrl="../../Purchase/Image/view.gif"
                                    CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                                <asp:TemplateField HeaderText="Location Type">
                                    <ItemTemplate>
                                        <asp:Label ID="lblLocationType" runat="server" Text='<%#Eval("LocationType") %>'></asp:Label>
                                        <asp:Label ID="lblLocationId" runat="server" Text='<%#Eval("locationid") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="AssetName">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAssetName" runat="server" Text='<%#Eval("AssetName") %>'></asp:Label>
                                        <asp:Label ID="lblAssetID" runat="server" Text='<%#Eval("AssetID") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="AssetCode">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAssetCode" runat="server" Text='<%#Eval("AssetCode") %>'></asp:Label>
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
                        &nbsp;Current Location
                    </div>
                    <div>
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 20%; text-align: right;">Location :</td>
                                <td style="width: 30%; text-align: left;">
                                    <asp:DropDownList ID="ddlLocation" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlLocation_SelectedIndexChanged" CssClass="ItDoseDropdownbox" Width="153px">
                                    </asp:DropDownList>
                                    <span class="ItDoseLblError">*</span>
                                </td>
                                <td style="width: 20%; text-align: right;">Floor :</td>
                                <td style="width: 30%; text-align: left;">
                                    <asp:DropDownList ID="ddlFloor" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlFloor_SelectedIndexChanged" CssClass="ItDoseDropdownbox" Width="153px">
                                    </asp:DropDownList>
                                    <span class="ItDoseLblError">*</span>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 20%; text-align: right;">Room :</td>
                                <td style="width: 30%; text-align: left;">
                                    <asp:DropDownList ID="ddlRoom" runat="server" CssClass="ItDoseDropdownbox" Width="153px">
                                    </asp:DropDownList>
                                    <span class="ItDoseLblError">*</span>
                                </td>
                                <td style="width: 20%; text-align: right;">Assigned To :</td>
                                <td style="width: 30%; text-align: left;">
                                    <asp:TextBox ID="txtAssignedTo" runat="server" CssClass="ItDoseTextinputText" Width="150px"></asp:TextBox>
                                    <span class="ItDoseLblError">*</span>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 20%; text-align: right;">Assigned On :</td>
                                <td style="width: 30%; text-align: left;">
                                    <asp:TextBox ID="ucAssignedOn" runat="server" ToolTip="Click To Select From Date" ClientIDMode="Static" CssClass="ItDoseTextinputText" Width="150px"></asp:TextBox>
                                    <span class="ItDoseLblError">*</span>
                                    <cc1:CalendarExtender ID="fc11" runat="server" TargetControlID="ucAssignedOn" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>
                                </td>
                                <td style="width: 20%; text-align: right;">Status :</td>
                                <td style="width: 30%; text-align: left;">
                                    <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="True" Visible="false" CssClass="ItDoseDropdownbox" Width="153px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 20%; display: none; text-align: right;">Machine ID :</td>
                                <td style="width: 30%; display: none; text-align: left;">
                                    <asp:Label ID="lblMachineId" runat="server"></asp:Label>
                                </td>
                                <td style="width: 20%; display: none; text-align: right;"></td>
                                <td style="width: 30%; display: none; text-align: left;"></td>
                            </tr>
                            <tr>
                                <td colspan="4">&nbsp;</td>
                            </tr>
                        </table>

                    </div>
                    <div class="POuter_Box_Inventory" style="width: 690px;">
                        <div class="Purchaseheader">
                            &nbsp;Change Location
                        </div>
                        <div>
                            <table style="width: 100%;">
                                <tr>
                                    <td style="width: 20%; text-align: right;">Location :</td>
                                    <td style="width: 30%; text-align: left;">
                                        <asp:DropDownList ID="ddlchangelocation" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlchangelocation_SelectedIndexChanged" CssClass="ItDoseDropdownbox" Width="153px">
                                        </asp:DropDownList>
                                        <span class="ItDoseLblError">*</span>
                                    </td>
                                    <td style="width: 20%; text-align: right;">Floor :</td>
                                    <td style="width: 30%; text-align: left;">
                                        <asp:DropDownList ID="ddlchangefloor" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlchangefloor_SelectedIndexChanged" CssClass="ItDoseDropdownbox" Width="153px">
                                        </asp:DropDownList>
                                        <span class="ItDoseLblError">*</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 20%; text-align: right;">Room :</td>
                                    <td style="width: 30%; text-align: left;">
                                        <asp:DropDownList ID="ddlchangeroom" runat="server" CssClass="ItDoseDropdownbox" Width="153px">
                                        </asp:DropDownList>
                                        <span class="ItDoseLblError">*</span>
                                    </td>
                                    <td style="width: 20%; text-align: right;">Assigned To :</td>
                                    <td style="width: 30%; text-align: left;">
                                        <asp:TextBox ID="txtassingedto" runat="server" CssClass="ItDoseTextinputText" Width="150px"></asp:TextBox>
                                        <span class="ItDoseLblError">*</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 20%; text-align: right;">Assigned On :</td>
                                    <td style="width: 30%; text-align: left;">
                                        <asp:TextBox ID="ucchangeAssignedOn" runat="server" ToolTip="Click To Select From Date" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText" Width="150px"></asp:TextBox>
                                        <span class="ItDoseLblError">*</span>
                                        <cc1:CalendarExtender ID="fc12" runat="server" TargetControlID="ucchangeAssignedOn" Format="dd-MMM-yyyy">
                                        </cc1:CalendarExtender>
                                    </td>
                                    <td style="width: 20%; text-align: right;">Status</td>
                                    <td style="width: 30%; text-align: left;">
                                        <asp:DropDownList ID="ddlchangestatus" Width="153px" runat="server" AutoPostBack="True" Visible="false" CssClass="ItDoseDropdownbox">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">&nbsp;</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="POuter_Box_Inventory" style="width: 690px;">
                        <table style="width: 100%">
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
            </asp:Panel>

            <asp:Panel ID="Panel3" runat="server" Visible="False">
                <div class="POuter_Box_Inventory" style="width: 690px;">
                    <div class="Purchaseheader">
                        Asset History
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="overflow: scroll; height: 445px; width: 690px;">
                    <asp:GridView ID="grdassethistory" runat="server" AutoGenerateColumns="false" CssClass="GridViewScrollHeaderStyle">
                        <Columns>
                            <asp:TemplateField HeaderText="AssetID">
                                <ItemTemplate>
                                    <%#Eval("AssetID")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
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

                            <asp:TemplateField HeaderText="Location">
                                <ItemTemplate>
                                    <%#Eval("locationname")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Floor">
                                <ItemTemplate>
                                    <%#Eval("floorname")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Room">
                                <ItemTemplate>
                                    <%#Eval("roomname")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="AssignTo">
                                <ItemTemplate>
                                    <%#Eval("AssignedTo")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="AssignDate">
                                <ItemTemplate>
                                    <%#Eval("Assignedate")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IsCurrent">
                                <ItemTemplate>
                                    <%#Eval("IsCurrent")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Insertby">
                                <ItemTemplate>
                                    <%#Eval("insertby")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Transferdate">
                                <ItemTemplate>
                                    <%#Eval("insertdate")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="updateby">
                                <ItemTemplate>
                                    <%#Eval("updateby")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="updatedate">
                                <ItemTemplate>
                                    <%#Eval("updatedate")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center; width: 690px;">
                    <asp:Button ID="btnInfoCancel" runat="server" OnClick="btnInfoCancel_Click" CssClass="ItDoseButton" Text="Cancel" CausesValidation="false" />
                </div>
            </asp:Panel>

            <%--<cc1:modalpopupextender id="mdlPatient" runat="server" CancelControlID="btnClose" 
    TargetControlID="btnHidden" BackgroundCssClass = "filterPupupBackground" PopupControlID="Panel3"
    X="100" Y="80">
    </cc1:modalpopupextender>
    <div  style="display:none;">
    <asp:Button ID="btnHidden" runat="server" Text="Button" />
    </div>
         <iframe id="iframePatient" name="iframePatient" src="" 
 style="position:fixed; top:0px; left:0px; background-color:#FFFFFF;display:none;"
  frameborder="0" enableviewstate="true" onclick="return iframePatient_onclick()" ></iframe>
 
         <cc1:ModalPopupExtender ID="updateroomInfo" runat="server"
    CancelControlID="btnInfoCancel"
    DropShadow="true"
    TargetControlID="btnHidden"
    BackgroundCssClass="filterPupupBackground"
    PopupControlID="Panel2"
    PopupDragHandleControlID="Div3" >
</cc1:ModalPopupExtender>--%>
        </div>
    </form>
</body>
</html>
