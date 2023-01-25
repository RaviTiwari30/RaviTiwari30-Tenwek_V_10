<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CaliberationType.aspx.cs"
    Inherits="Design_Equipment_Transactions_CaliberationType" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="stylesheet" href="../../../Styles/PurchaseStyle.css" />
    <link href="../../../Styles/grid24.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        .auto-style1
        {
            width: 185px;
        }
        .auto-style2 {
            height: 14px;
            width: 20%;
        }
        .auto-style3 {
            width: 20%;
        }
        .auto-style4 {
            height: 26px;
            width: 20%;
        }
        .auto-style5 {
            height: 16px;
            width: 20%;
        }
    </style>

</head>

<body style="margin-top: 1px; margin-left: 1px;overflow:hidden;">
    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%=chkcalibration.ClientID %>").click(function () {
                var con = $("#<%=chkcalibration.ClientID %> input[type=radio]:checked").val();
                if (con == "1")
                    $("#<%=txtdate.ClientID %>").show();
                else
                    $("#<%=txtdate.ClientID %>").hide();
            });
            var con1 = $("#<%=chkcalibration.ClientID %> input[type=radio]:checked").val();
            if (con1 == "1")
                $("#<%=txtdate.ClientID %>").show();
            else
                $("#<%=txtdate.ClientID %>").hide();

        });

    </script>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="pnlab" runat="server"></Ajax:ScriptManager>
        <div id="Pbody_box_inventory" style="width: 100%;">
            <div class="POuter_Box_Inventory" style="text-align: center; width: 100%;">
                <b>Calibration Type</b><br />
                <asp:Label ID="lblmsg" runat="server" ForeColor="Red"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 100%;">
                <div class="row">
                    <div class="col-md-3">
                            <label class="pull-left">Machine Name</label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-5">
                           <asp:TextBox ID="txtmachinename" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                    <div class="col-md-3">
                            <label class="pull-left">Asset Code</label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-5">
                           <asp:TextBox ID="txtassetcode" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>
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
                <div style="overflow: scroll; height: 400px; width: 99%;">
                    <asp:GridView ID="grdSupplierType" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                        Width="650px" Height="141px" OnRowCommand="grdSupplierType_RowCommand" OnRowDataBound="grdSupplierType_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="Name">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("AssetName")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Asset Code">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("AssetCode")%>
                                    <asp:Label ID="lblActive" runat="server" Text='<%#Eval("IsActive") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Set">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbSelect" CommandName="Select" CommandArgument=' <%#Eval("AssetName")+"#"+Eval("AssetCode")%>' ToolTip="Select" runat="server" ImageUrl="~/Images/Post.gif" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Log">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="~/Images/view.GIF"
                                        CausesValidation="false" CommandArgument='<%# Eval("CalibrationID")%>' CommandName="ViewLog" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" ToolTip="Edit Floor" runat="server" ImageUrl="~/Images/edit.png"
                                        CausesValidation="false" CommandArgument='<%# Eval("CalibrationID")%>' CommandName="EditData" />
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <div style="text-align: center;">
                <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server"
                    BackgroundCssClass="filterPupupBackground"
                    PopupControlID="pnlUpdate"
                    PopupDragHandleControlID="dragHandle" TargetControlID="btnHidden">
                </cc1:ModalPopupExtender>
                <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlItemsFilter" Width="592px" >
                    <div style="text-align: center; width: 592px;">
                        <div class="Purchaseheader">Machine Calibration Set </div>
                        <div class="content" style="text-align: center; width: 592px"">
                            <table>
                                <tr>
                                    <td style="text-align: left; " class="auto-style2">Machine Name :</td>
                                    <td style="text-align: left; height: 14px;">
                                        <asp:TextBox ID="txtMName" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    </td>
                                    <td style="text-align: right; height: 14px;">Asset Code :</td>
                                    <td style="text-align: left; height: 14px;">
                                        <asp:TextBox ID="txtAcode" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    </td>

                                </tr>
                                <tr>
                                    <td style="text-align: right;" class="auto-style3">Calibra.. Type :
                                    </td>
                                    <td style="text-align: left; height: 26px;">

                                        <asp:DropDownList ID="ddlCaliType" runat="server">
                                            <asp:ListItem>Annually</asp:ListItem>
                                            <asp:ListItem>BioAnnually</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td style="text-align: right; height: 26px;">Calibration :
            
                                    </td>
                                    <td>

                                        <asp:RadioButtonList ID="chkcalibration" runat="server" RepeatDirection="Horizontal" Width="82px" AutoPostBack="false" OnSelectedIndexChanged="chkcalibration_SelectedIndexChanged">
                                            <asp:ListItem Value="1" Text="Yes"></asp:ListItem>
                                            <asp:ListItem Value="0" Text="NO"></asp:ListItem>
                                        </asp:RadioButtonList>

                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right; " class="auto-style4">Due Date :
                                    </td>
                                    <td style="text-align: left; height: 26px">
                                        <asp:TextBox ID="txtdate" runat="server" OnTextChanged="txtdate_TextChanged" AutoPostBack="True" CssClass="ItDoseTextinputText"></asp:TextBox>
                                        <%-- <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
                </cc1:ToolkitScriptManager>--%>

                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtdate" Format="dd-MMM-yyyy">
                                        </cc1:CalendarExtender>
                                    </td>
                                    <td style="text-align: right; height: 26px;">Next Date :
                                    </td>
                                    <td style="text-align: left; height: 26px;">
                                        <asp:TextBox ID="txtdate1" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtdate1" Format="dd-MMM-yyyy">
                                        </cc1:CalendarExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" class="auto-style5">&nbsp;</td>
                                    <td style="text-align: right; height: 26px;">
                                        <asp:Button ID="btnClose" runat="server" Text="Close" OnClick="btnClose_Click" CssClass="ItDoseButton" />
                                    </td>
                                    <td style="text-align: left; height: 26px;">
                                        <asp:Button ID="btnsave" runat="server" Text="Save" OnClick="btnsave_Click1" CssClass="ItDoseButton" />
                                    </td>
                                </tr>


                            </table>
                        </div>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlLog" runat="server" Style="width: 500px; border: outset; background-color: #EAF3FD; display: none;">
                    <div id="Div1" class="Purchaseheader" style="text-align: center">Log Detail </div>
                    <div style="overflow: scroll; height: 250px; width: 495px; text-align: left; border: groove;">
                        <asp:Label ID="lblLog" runat="server"></asp:Label>
                    </div>
                    <div style="text-align: center;">
                        <asp:Button ID="Button1" runat="server" CssClass="ItDoseButton"
                            Text="Close" />
                    </div>
                </asp:Panel>
                <cc1:ModalPopupExtender ID="mdpLog" runat="server" CancelControlID="Button1"
                    TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlLog"
                    X="100" Y="80">
                </cc1:ModalPopupExtender>
                <div style="display: none">
                    <asp:Button ID="btnHidden" runat="server" Text="Button" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
