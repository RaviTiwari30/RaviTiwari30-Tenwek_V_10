<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Op_Flow_Sheet.aspx.cs" Inherits="Design_OT_PRE_Op_Flow_Sheet" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head runat="server">
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />

    <title></title>
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <style type="text/css">
     
        .accordionHeader
        {
            border: 1px solid #2F4F4F;
            color: white;
            background-color: #808080;
            font-family: Arial, Sans-Serif;
            font-size: 12px;
            font-weight: bold;
            padding: 5px;
            margin-top: 5px;
            cursor: pointer;
        }
       
        .accordionHeaderSelected
        {
            border: 1px solid #2F4F4F;
            color: white;
            background-color: #808080;
            font-family: Arial, Sans-Serif;
            font-size: 12px;
            font-weight: bold;
            padding: 5px;
            margin-top: 5px;
            cursor: pointer;
        }
        
        .accordionContent
        {
            background-color: white;
            border: 1px dashed #2F4F4F;
            border-top: none;
            padding: 5px;
            padding-top: 10px;
        }
    </style>
</head>
<body>
    <script type="text/javascript">

        $(document).ready(function () {

            var LoginType = '<%= Session["LoginType"].ToString() %>';

            $("#<%=gridPrep.ClientID %> tr").each(function () {
                if (LoginType == "2 BED WARD" || LoginType == "4 BED WARD") {
                    if ($(this).closest("tr").find("input[type=checkbox][id*=chkWardPrep]").is(":checked") == true) {
                        $(this).closest("tr").find("input[type=text][id*=txtWardCommentPrep]").attr("disabled", false);
                    }
                    else {
                        $(this).closest("tr").find("input[type=text][id*=txtWardCommentPrep]").attr("disabled", true);
                    }

                }
                if (LoginType == "OR") {
                    if ($(this).closest("tr").find("input[type=checkbox][id*=chkOTPrep]").is(":checked") == true) {
                        $(this).closest("tr").find("input[type=text][id*=txtOtCommentPrep]").attr("disabled", false);
                    }
                    else {
                        $(this).closest("tr").find("input[type=text][id*=txtOtCommentPrep]").attr("disabled", true);
                    }

                }
                if (LoginType == "ICU") {
                    if ($(this).closest("tr").find("input[type=checkbox][id*=chkPACPrep]").is(":checked") == true) {
                        $(this).closest("tr").find("input[type=text][id*=txtPacCommentPrep]").attr("disabled", false);
                    }
                    else {
                        $(this).closest("tr").find("input[type=text][id*=txtPacCommentPrep]").attr("disabled", true);
                    }

                }
            });
            $("input[type=checkbox][id*=chkWardPrep]").click(function () {
                if (this.checked) {
                    $(this).closest("tr").find("input[type=text][id*=txtWardCommentPrep]").attr("disabled", false);
                }
                else {
                    $(this).closest("tr").find("input[type=text][id*=txtWardCommentPrep]").attr("disabled", true).val('');
                }
            });
            $("input[type=checkbox][id*=chkOTPrep]").click(function () {

                if (this.checked) {
                    $(this).closest("tr").find("input[type=text][id*=txtOtCommentPrep]").attr("disabled", false);
                }
                else {
                    $(this).closest("tr").find("input[type=text][id*=txtOtCommentPrep]").attr("disabled", true).val('');
                }
            });
            $("input[type=checkbox][id*=chkPACPrep]").click(function () {
                if (this.checked) {
                    $(this).closest("tr").find("input[type=text][id*=txtPacCommentPrep]").attr("disabled", false);
                }
                else {
                    $(this).closest("tr").find("input[type=text][id*=txtPacCommentPrep]").attr("disabled", true).val('');
                }
            });

            $("#<%=gridBelong.ClientID %> tr").each(function () {

                if (LoginType == "2 BED WARD" || LoginType == "4 BED WARD") {


                    if ($(this).closest("tr").find("input[type=checkbox][id*=chkWardBelong]").is(":checked") == true) {
                        $(this).closest("tr").find("input[type=text][id*=txtWardCommentBelong]").attr("disabled", false);
                    }
                    else {

                        $(this).closest("tr").find("input[type=text][id*=txtWardCommentBelong]").attr("disabled", true);
                    }

                }
                if (LoginType == "OR") {

                    if ($(this).closest("tr").find("input[type=checkbox][id*=chkOTBelong]").is(":checked") == true) {
                        $(this).closest("tr").find("input[type=text][id*=txtOtCommentBelong]").attr("disabled", false);
                    }
                    else {

                        $(this).closest("tr").find("input[type=text][id*=txtOtCommentBelong]").attr("disabled", true);
                    }

                }
                if (LoginType == "ICU") {
                    if ($(this).closest("tr").find("input[type=checkbox][id*=chkPACBelong]").is(":checked") == true) {
                        $(this).closest("tr").find("input[type=text][id*=txtPacCommentBelong]").attr("disabled", false);
                    }
                    else {
                        $(this).closest("tr").find("input[type=text][id*=txtPacCommentBelong]").attr("disabled", true);
                    }
                }

            });
            $("input[type=checkbox][id*=chkWardBelong]").click(function () {
                if (this.checked) {
                    $(this).closest("tr").find("input[type=text][id*=txtWardCommentBelong]").attr("disabled", false);
                }
                else {
                    $(this).closest("tr").find("input[type=text][id*=txtWardCommentBelong]").attr("disabled", true).val('');

                }
            });
            $("input[type=checkbox][id*=chkOTBelong]").click(function () {
                if (this.checked) {
                    $(this).closest("tr").find("input[type=text][id*=txtOtCommentBelong]").attr("disabled", false);
                }
                else {
                    $(this).closest("tr").find("input[type=text][id*=txtOtCommentBelong]").attr("disabled", true).val('');

                }
            });
            $("input[type=checkbox][id*=chkPACBelong]").click(function () {
                if (this.checked) {
                    $(this).closest("tr").find("input[type=text][id*=txtPacCommentBelong]").attr("disabled", false);
                }
                else {
                    $(this).closest("tr").find("input[type=text][id*=txtPacCommentBelong]").attr("disabled", true).val('');

                }
            });

            $("#<%=grdRoom.ClientID %> tr").each(function () {
                if (LoginType == "2 BED WARD" || LoginType == "4 BED WARD") {
                    if ($(this).closest("tr").find("input[type=checkbox][id*=chkWardRoom]").is(":checked") == true) {
                        $(this).closest("tr").find("input[type=text][id*=txtWardCommentRoom]").attr("disabled", false);
                    }
                    else {
                        $(this).closest("tr").find("input[type=text][id*=txtWardCommentRoom]").attr("disabled", true);
                    }

                }
                if (LoginType == "OR") {
                    if ($(this).closest("tr").find("input[type=checkbox][id*=chkOTRoom]").is(":checked") == true) {
                        $(this).closest("tr").find("input[type=text][id*=txtOtCommentRoom]").attr("disabled", false);
                    }
                    else {
                        $(this).closest("tr").find("input[type=text][id*=txtOtCommentRoom]").attr("disabled", true);
                    }

                }
                if (LoginType == "ICU") {
                    if ($(this).closest("tr").find("input[type=checkbox][id*=chkPACRoom]").is(":checked") == true) {
                        $(this).closest("tr").find("input[type=text][id*=txtPacCommentRoom]").attr("disabled", false);
                    }
                    else {
                        $(this).closest("tr").find("input[type=text][id*=txtPacCommentRoom]").attr("disabled", true);
                    }
                }

            });
            $("input[type=checkbox][id*=chkWardRoom]").click(function () {
                if (this.checked) {
                    $(this).closest("tr").find("input[type=text][id*=txtWardCommentRoom]").attr("disabled", false);
                }
                else {
                    $(this).closest("tr").find("input[type=text][id*=txtWardCommentRoom]").attr("disabled", true).val('');

                }
            });
            $("input[type=checkbox][id*=chkOTRoom]").click(function () {
                if (this.checked) {
                    $(this).closest("tr").find("input[type=text][id*=txtOtCommentRoom]").attr("disabled", false);
                }
                else {
                    $(this).closest("tr").find("input[type=text][id*=txtOtCommentRoom]").attr("disabled", true).val('');

                }
            });
            $("input[type=checkbox][id*=chkPACBelong]").click(function () {
                if (this.checked) {
                    $(this).closest("tr").find("input[type=text][id*=txtPacCommentRoom]").attr("disabled", false);
                }
                else {
                    $(this).closest("tr").find("input[type=text][id*=txtPacCommentRoom]").attr("disabled", true).val('');

                }
            });

        });

    </script>
    <form id="form1" runat="server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Patient Op Flow Sheet </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
                <div style="overflow: auto; text-align: center">
                    <asp:GridView ID="grisearch" runat="server"
                        AutoGenerateColumns="False" CssClass="GridViewStyle" Width="100%" OnRowCommand="grisearch_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="CPT Code" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblCptcode" runat="server" Text='<%# Eval("CPTCode") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Surgery" ItemStyle-Width="40%" HeaderText="Surgery" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="Name" HeaderText="Enter By" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="EnterDate" HeaderText="Enter Date" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:TemplateField HeaderText="View" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Button ID="Button1" runat="server" Text="View" CssClass="ItDoseButton" ToolTip="Click to Print"
                                        CommandName="btnPrint" CommandArgument='<%#Eval("TransactionID")+"#"+Eval("Patient_surgery_id")%>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                Flow Sheet
            </div>
            <div id="accordion">
                <cc1:Accordion ID="Accordion1" runat="server" CssClass="accordion" HeaderCssClass="accordionHeader" HeaderSelectedCssClass="accordionHeaderSelected" ContentCssClass="accordionContent">
                    <Panes>
                        <cc1:AccordionPane ID="AccordionPane1" runat="server">
                            <Header>
                                Patient Preparation</Header>
                            <Content>
                                <asp:GridView ID="gridPrep" Width="99%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                    HorizontalAlign="left" OnRowDataBound="gridPrep_RowDataBound">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText=" S.No.">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Items">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="280px" />
                                            <ItemTemplate>
                                                <asp:Label ID="lblItemsPrep" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                                                <asp:Label ID="lblIDPrep" runat="server" Text='<%#Eval("ID") %>' Visible="false"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ward">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkWardPrep" runat="server" Visible='<%#Convert.ToBoolean(Eval("IsWard"))%>'>
                                                </asp:CheckBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ward Comment">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtWardCommentPrep" MaxLength="200" Visible='<%#Convert.ToBoolean(Eval("IsWard"))%>'
                                                    runat="server" Text='<%#Eval("WardComment") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="PAC">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkPACPrep" runat="server" Visible='<%#Convert.ToBoolean(Eval("IsPac"))%>'>
                                                </asp:CheckBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="PAC Comment">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtPacCommentPrep" MaxLength="200" Visible='<%#Convert.ToBoolean(Eval("IsPac"))%>'
                                                    runat="server" Text='<%#Eval("PacComment") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="OR">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkOTPrep" runat="server" Visible='<%#Convert.ToBoolean(Eval("IsOT"))%>'>
                                                </asp:CheckBox>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="OR Comment">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtOtCommentPrep" MaxLength="200" Visible='<%#Convert.ToBoolean(Eval("IsOT"))%>'
                                                    runat="server" Text='<%#Eval("OTComment") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </Content>
                        </cc1:AccordionPane>
                        <cc1:AccordionPane ID="AccordionPane2" runat="server">
                            <Header>
                                Patient Belongings</Header>
                            <Content>
                                <asp:GridView ID="gridBelong" Width="99%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" HorizontalAlign="left" OnRowDataBound="gridBelong_RowDataBound">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText=" S.No.">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Items">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="260px" />
                                            <ItemTemplate>
                                                <asp:Label ID="lblItemsBelong" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                                                <asp:Label ID="lblIDBelong" runat="server" Text='<%#Eval("ID") %>' Visible="false"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ward">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkWardBelong" runat="server" Visible='<%#Convert.ToBoolean(Eval("IsWard"))%>'>
                                                </asp:CheckBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ward Comment">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtWardCommentBelong" MaxLength="200" Visible='<%#Convert.ToBoolean(Eval("IsWard"))%>'
                                                    runat="server" Text='<%#Eval("WardComment") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="PAC">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkPACBelong" runat="server" Visible='<%#Convert.ToBoolean(Eval("IsPac"))%>'>
                                                </asp:CheckBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="PAC Comment">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtPacCommentBelong" MaxLength="200" Visible='<%#Convert.ToBoolean(Eval("IsPac"))%>'
                                                    runat="server" Text='<%#Eval("PacComment") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="OR">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkOTBelong" runat="server" Visible='<%#Convert.ToBoolean(Eval("IsOT"))%>'>
                                                </asp:CheckBox>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="OR Comment">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtOtCommentBelong" MaxLength="200" Visible='<%#Convert.ToBoolean(Eval("IsOT"))%>'
                                                    runat="server" Text='<%#Eval("OTComment") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </Content>
                        </cc1:AccordionPane>
                        <cc1:AccordionPane ID="AccordionPane3" runat="server">
                            <Header>
                                Operating Rooms Preparation
                            </Header>
                            <Content>
                                <asp:GridView ID="grdRoom" Width="99%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" HorizontalAlign="left" OnRowDataBound="grdRoom_RowDataBound">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText=" S.No.">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Items">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                            <ItemTemplate>
                                                <asp:Label ID="lblItemsRoom" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                                                <asp:Label ID="lblIDRoom" runat="server" Text='<%#Eval("ID") %>' Visible="false"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ward">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkWardRoom" runat="server" Visible='<%#Convert.ToBoolean(Eval("IsWard"))%>'>
                                                </asp:CheckBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ward Comment">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtWardCommentRoom" MaxLength="200" Visible='<%#Convert.ToBoolean(Eval("IsWard"))%>'
                                                    runat="server" Text='<%#Eval("WardComment") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="PAC">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkPACRoom" runat="server" Visible='<%#Convert.ToBoolean(Eval("IsPac"))%>'>
                                                </asp:CheckBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="PAC Comment">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtPacCommentRoom" MaxLength="200" Visible='<%#Convert.ToBoolean(Eval("IsPac"))%>'
                                                    runat="server" Text='<%#Eval("PacComment") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="OR">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkOTRoom" runat="server" Visible='<%#Convert.ToBoolean(Eval("IsOT"))%>'>
                                                </asp:CheckBox>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="OR Comment">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtOtCommentRoom" MaxLength="200" Visible='<%#Convert.ToBoolean(Eval("IsOT"))%>'
                                                    runat="server" Text='<%#Eval("OTComment") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </Content>
                        </cc1:AccordionPane>
                        <cc1:AccordionPane ID="AccordionPane4" runat="server" Visible="false">
                            <Header>
                                Medication Taken Morning of Surgery By Patient</Header>
                            <Content>
                              <%--  <div class="POuter_Box_Inventory" style="text-align: center;">
                                    <b>Pre-Op Medication Given:(Dose/Route/Time):</b>
                                </div>
                                <div class="POuter_Box_Inventory" style="text-align: center">--%>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 99%; text-align: left">
                                        <tr style="display: none">
                                            <td style="text-align: left" colspan="11">
                                                <asp:Label ID="lblWeight" runat="server" CssClass="ItDoseLabelBl"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr style="display:none">
                                            <td colspan="2">
                                                &nbsp;Medicine&nbsp;Name :&nbsp;
                                            </td>
                                            <td colspan="4">
                                                <asp:TextBox ID="txtSearch" runat="server" Width="447px" Height="19px" onKeyDown="MoveUpAndDownText(txtSearch,lstInv);"
                                                    onKeyUp="suggestName(txtSearch,lstInv);" TabIndex="1" ToolTip="Enter To Search" />
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td colspan="4">
                                                Item Code :
                                                <asp:TextBox ID="txtcpt" runat="server" Width="118px" onkeyup="javascript:ValidateCharactercount(10,this);" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                &nbsp;
                                            </td>
                                            <td colspan="4">
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td colspan="4">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 4%; text-align: left">
                                            </td>
                                            <td valign="top" style="text-align: right">
                                                Medicine :&nbsp;
                                            </td>
                                            <td colspan="9">
                                                <asp:ListBox ID="lstInv" CssClass="requiredField" runat="server" Width="457px" Height="121px"></asp:ListBox>
                                                
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 4%; text-align: left">
                                            </td>
                                            <td style="text-align: left" class="style2">
                                                &nbsp;
                                            </td>
                                            <td colspan="5">
                                                &nbsp;
                                            </td>
                                            <td style="width: 10%">
                                            </td>
                                            <td style="width: 14%">
                                            </td>
                                            <td class="">
                                            </td>
                                            <td style="width: 43%">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 4%; text-align: left">
                                            </td>
                                            <td style="text-align: right" class="style2">
                                                Dose :&nbsp;
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddldose" CssClass="requiredField" runat="server" Width="70px" ToolTip="Select Dose" TabIndex="2">
                                                </asp:DropDownList>
                                            </td>
                                            <td align="right">
                                                Times :&nbsp;
                                            </td>
                                            <td align="left">
                                                <asp:DropDownList ID="ddlTime" CssClass="requiredField" runat="server" Width="70px" ToolTip="Select Time"
                                                    TabIndex="3">
                                                </asp:DropDownList>
                                                
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td style="width: 10%; text-align: right">
                                                &nbsp;
                                            </td>
                                            <td style="width: 14%">
                                                &nbsp;
                                            </td>
                                            <td style="text-align: right" class="">
                                                Duration :&nbsp;
                                            </td>
                                            <td style="width: 43%">
                                                <asp:DropDownList ID="ddlDays" CssClass="requiredField" runat="server" Width="59px" ToolTip="Select Days"
                                                    TabIndex="4">
                                                </asp:DropDownList>
                                                
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 4%; text-align: left">
                                            </td>
                                            <td style="text-align: left" class="style2">
                                                &nbsp;
                                            </td>
                                            <td colspan="5">
                                                &nbsp;
                                            </td>
                                            <td style="width: 10%">
                                            </td>
                                            <td style="width: 14%">
                                            </td>
                                            <td class="">
                                            </td>
                                            <td style="width: 43%">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 4%; text-align: left">
                                            </td>
                                            <td style="text-align: left" class="style2">
                                            </td>
                                            <td colspan="5">
                                            </td>
                                            <td style="width: 10%">
                                            </td>
                                            <td style="width: 14%">
                                            </td>
                                            <td class="">
                                            </td>
                                            <td style="width: 43%">
                                                <asp:Label ID="lblDoctor" runat="server" Visible="False"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="9" style="width: 14%; text-align: center">
                                                <asp:Button ID="btnAdd" Text="Add" runat="server" CssClass="ItDoseButton" OnClick="btnAdd_Click"
                                                    TabIndex="6" ToolTip="Click To Add" />
                                            </td>
                                        </tr>
                                    </table>
                               <%-- </div>--%>
                               <%-- <div class="POuter_Box_Inventory" style="text-align: left;">
                                    Medicines
                                </div>--%>
                              <%--  <div class="POuter_Box_Inventory" style="text-align: center">--%>
                                <br />
                                    <asp:GridView ID="grdMedicine" runat="server" Width="99%" AutoGenerateColumns="false" CssClass="GridViewStyle"
                                        OnRowCommand="grdMedicine_RowCommand">
                                        <Columns>
                                            <asp:TemplateField HeaderText=" S.No." HeaderStyle-Width="35px" ItemStyle-CssClass="GridViewItemStyle"
                                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <%#Container.DataItemIndex+1 %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Medicine Name" HeaderStyle-Width="250px" ItemStyle-CssClass="GridViewItemStyle"
                                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblMedicine" runat="server" Text='<%#Eval("Medicine") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Dose" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblDose" runat="server" Text=' <%#Eval("Dose")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Times" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblTimes" runat="server" Text=' <%#Eval("Time") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Duration" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblDays" runat="server" Text=' <%#Eval("Days") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Reject" HeaderStyle-Width="45px" ItemStyle-CssClass="GridViewItemStyle"
                                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="imgRemove" runat="server" ImageUrl="~/Images/Delete.gif" CommandName="imbRemove"
                                                        CommandArgument='<%#Container.DataItemIndex %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="ID" Visible="false">
                                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                                <ItemTemplate>
                                                    <asp:Label ID="lblid" Visible="false" runat="server" Text='<%# Eval("MedicineID") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                               <%-- </div>--%>
                            </Content>
                        </cc1:AccordionPane>
                        <cc1:AccordionPane ID="AccordionPane6" runat="server">
                            <Header>
                                Hands-Off Report(including Opportunity to ask & respond to questions)
                            </Header>
                            <Content>
                               <%-- <div class="POuter_Box_Inventory" style="text-align: center;">
                                    <b>Hand-Off Report</b>(including Opportunity to ask & respond to questions):
                                </div>--%>
                                <div  style="text-align: center">
                                    <asp:GridView ID="grdCancelled" runat="server" Width="99%" AutoGenerateColumns="false"
                                        CssClass="GridViewStyle">
                                        <Columns>
                                            <asp:TemplateField HeaderText=" S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <%#Container.DataItemIndex+1 %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblID" runat="server" Text='<%#Eval("ID") %>' Visible="false"></asp:Label>
                                                    <asp:Label ID="lblTitle" runat="server" Text='<%#Eval("Title") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <asp:TextBox ID="txtTitleDetail" Text='<%#Eval("TitleDetail") %>' MaxLength="100"
                                                        runat="server"></asp:TextBox>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Date" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <asp:TextBox ID="ucDate" runat="server" Font-Names="Verdana" Font-Size="8pt" Text='<%#Eval("Date")%>'
                                                        Width="92px"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="fc1" runat="server" PopupButtonID="ucDate" TargetControlID="ucDate"
                                                        Format="dd-MMM-yyyy">
                                                    </cc1:CalendarExtender>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Time" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <asp:TextBox ID="txtTime" runat="server" TabIndex="2" Text='<%#Eval("Time")%>' ToolTip="Enter Follow up Time"
                                                        Width="70px" MaxLength="5" />
                                                    <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                                        TargetControlID="txtTime" AcceptAMPM="true">
                                                    </cc1:MaskedEditExtender>
                                                    <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                                        ControlExtender="masTime" Display="Static" InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </Content>
                        </cc1:AccordionPane>
                    </Panes>
                </cc1:Accordion>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <table width="100%">
                    <tr>
                        <td>
                            <asp:Label ID="lblUserName" runat="server" Text="" Style="font-weight: 700; color: #0000CC"></asp:Label>
                        </td><td style="width:50%">
                        <asp:Button ID="btnSave" runat="server"  Text="Save" OnClick="btnSave_Click" CssClass="save margin-top-on-btn" />
                        <asp:Button ID="btnApprove" runat="server" Text="Approve" Visible="false" CssClass="save margin-top-on-btn" />
                        <asp:Button ID="btnPrint" runat="server" Text="Print" Visible="false" CssClass="save margin-top-on-btn"
                            OnClick="btnPrint_Click" />
                        </td>
                    </tr>
                </table>
        </div>
    </div>
    </form>
</body>
</html>
