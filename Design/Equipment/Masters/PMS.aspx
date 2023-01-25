<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PMS.aspx.cs" Inherits="Design_Equipment_Masters_PMS" %>

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
            width: 173px;
        }
    </style>
</head>
<body style="overflow:hidden;">
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="pnlab" runat="server"></Ajax:ScriptManager>
        <div id="Pbody_box_inventory" style="width: 100%;">
            <div class="POuter_Box_Inventory" style="width: 1031px;text-align:center;">
                <b>Preventive Maintenance Schedule</b>&nbsp;<br />
                <asp:Label ID="lblmsg" runat="server" ForeColor="Red"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory" style="width: 100%;">
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
                            <asp:TextBox ID="txtassestcode" runat="server"></asp:TextBox>
                        </div>
                </div>
            </div>
             <div class="POuter_Box_Inventory" style="text-align: center; width: 100%;">
                <table style="width: 100%;">
                    <tr>
                        <td style="text-align: center;">
                            <asp:Button ID="Button1" runat="server" Text="Search" OnClick="btnsearch_Click" CssClass="ItDoseButton" />
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="width: 100%;">
                <div class="content" style="overflow: scroll; height: 420px; width: 99%;">
                    <asp:GridView ID="grdpms" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                        Width="650px" Height="141px" OnRowCommand="grdpms_RowCommand" OnRowDataBound="grdpms_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="Machine Name">
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
                                    <asp:Label ID="lblActive" runat="server" Text='<%#Eval("IsActive")%>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Select">
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
                                        CausesValidation="false" CommandArgument='<%# Eval("PMSID")%>' CommandName="ViewLog" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" ToolTip="Edit Floor" runat="server" ImageUrl="~/Images/edit.png"
                                        CausesValidation="false" CommandArgument='<%# Eval("PMSID")%>' CommandName="EditData" />
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </div>
            </div>



            <div style="text-align: center;">
                <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" BackgroundCssClass="filterPupupBackground"
                    PopupControlID="pnlUpdate"
                    PopupDragHandleControlID="dragHandle" TargetControlID="btnHidden">
                </cc1:ModalPopupExtender>
                <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlItemsFilter" Width="592px" style="display:none;">
                    <div class="POuter_Box_Inventory" style="text-align: center; width: 592px">
                        <div class="Purchaseheader">PMS</div>
                        <div class="content" style="text-align: center; width: 592px">
                            <table class="ItDoseLabel">
                                <tr>
                                    <td style="text-align: right; height: 26px">Machine Name :
                                    </td>

                                    <td style="text-align: left; height: 26px">
                                        <asp:TextBox ID="txtgrdMName" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>

                                    </td>
                                    <td style="text-align: right; height: 26px">Code :
                                    </td>
                                    <td style="text-align: left; height: 26px">
                                        <asp:TextBox ID="txtgrdAcode" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    </td>
                                    <td style="text-align: left; height: 15px">&nbsp;</td>
                                    <td style="text-align: left; height: 26px">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="text-align: right; height: 26px">Last PMS Done Date :
                                    </td>
                                    <td style="text-align: left; height: 26px">
                                        <asp:TextBox ID="txtLastDone" runat="server" AutoPostBack="True" OnTextChanged="txtLastDone_TextChanged"></asp:TextBox>

                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtLastDone" Format="dd-MMM-yyyy">
                                        </cc1:CalendarExtender>
                                    </td>
                                    <td style="text-align: right; height: 26px">Due Date :
                                    </td>
                                    <td style="text-align: left; height: 26px">
                                        <asp:TextBox ID="txtduedate" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>

                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtduedate" Format="dd-MMM-yyyy">
                                        </cc1:CalendarExtender>
                                    </td>

                                </tr>
                                <tr>
                                    <td style="width: 20%; text-align: right">Frequency Type: </td>
                                    <td colspan="4" style="text-align: left">
                                        <asp:DropDownList ID="ddlfreqncytype" runat="server" CssClass="ItDoseDropdownbox" Width="200px">
                                            <asp:ListItem>Annually</asp:ListItem>
                                            <asp:ListItem>BioAnnually</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 20%">PMS Deliverables.(500 characters)</td>
                                    <td colspan="4" style="width: 20%">
                                        <asp:TextBox ID="txtpmsdlivrable" runat="server" CssClass="ItDoseTextinputText" Height="61px" TextMode="MultiLine" Width="384px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="text-align: right; height: 26px">

                                        <asp:Button ID="btnclose1" runat="server" Text="Close" OnClick="btnclose1_Click" CssClass="ItDoseButton" />
                                    </td>
                                    <td style="text-align: left">
                                        <asp:Button ID="btnsave" runat="server" Text="Save" OnClick="btnsave_Click" CssClass="ItDoseButton" /></td>
                                </tr>
                            </table>
                            <div style="display: none;">
                                <asp:Button ID="btnHidden" runat="server" Text="Button" />
                            </div>
                        </div>
                    </div>
                </asp:Panel>
            </div>

            <asp:Panel ID="pnlLog" runat="server" Style="width: 500px; border: outset; background-color: #EAF3FD; display: none;">
                <div id="Div1" class="Purchaseheader" style="text-align: center">Log Detail </div>
                <div style="overflow: scroll; height: 250px; width: 495px; text-align: left; border: groove;">
                    <asp:Label ID="lblLog" runat="server"></asp:Label>
                </div>
                <div style="text-align: center;">
                    <asp:Button ID="btnClose" runat="server" CssClass="ItDoseButton"
                        Text="Close" />
                </div>
            </asp:Panel>
            <cc1:ModalPopupExtender ID="mdpLog" runat="server" CancelControlID="btnClose"
                TargetControlID="btnhidden1" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlLog"
                X="100" Y="80">
            </cc1:ModalPopupExtender>
            <div style="display: none;">
                <asp:Button ID="btnHidden1" runat="server" Text="Button" />
            </div>
        </div>
    </form>
</body>
</html>
