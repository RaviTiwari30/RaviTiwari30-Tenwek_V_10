<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewDischargeSummary.aspx.cs" Inherits="Design_IPD_ViewDischargeSummary" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />

    <link href="../../Styles/grid24.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript">

    </script>
    <form id="form1" runat="server">



        <Ajax:ScriptManager ID="sm" runat="server" />
        <Ajax:UpdatePanel ID="up" runat="server">
            <ContentTemplate>
                <div id="Pbody_box_inventory">
                    <div class="POuter_Box_Inventory">
                        <div class="content" style="text-align: center;">
                            <b>View Discharge Summary</b>
                            <br />
                            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                        </div>

                    </div>

                    <div class="POuter_Box_Inventory">
                        <div class="content" style="text-align: center; display: none">
                            &nbsp;<br />
                            <br />
                            &nbsp;&nbsp;
                <asp:Button ID="btnDischarge" runat="server" OnClick="btnDischarge_Click" Text="Discharge Summary"
                    CssClass="ItDoseButton" Visible="false" />
                            &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;
                        </div>
                        <div class="content">
                            <div class="row">
                                <div class="col-sm-2">

                                    <asp:CheckBox runat="server" ID="chkid" />
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Discharge Date     </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date"
                                        ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Discharge Time </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-6">
                                    <asp:TextBox ID="txtTime" runat="server" MaxLength="5" ToolTip="Enter Time"
                                        TabIndex="2" />
                                    <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                        TargetControlID="txtTime" AcceptAMPM="true">
                                    </cc1:MaskedEditExtender>

                                    <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                        ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required"
                                        InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                                    <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                                </div>

                            </div>



                        </div>

                        <asp:GridView ID="grdDischargeSummary" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" OnRowCommand="grdDischargeSummary_RowCommand">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="IPD No.">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIPDNo" runat="server" Text='<%# Eval("IPDNo") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Entry Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDATE" runat="server" Text='<%# Eval("DATE") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Created By">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEntryBy" runat="server" Text='<%# Eval("EntryBy") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("DStatus") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Date of Discharge">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDateOfDischarge" runat="server" Text='<%# Eval("DateOfDischarge") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="View">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgbtnEdit" AlternateText="View" CommandName="aView" CommandArgument='<%#Eval("TransactionID") +"#"+Eval("Status") %>' ImageUrl="~/Images/view.GIF" runat="server" />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

            </ContentTemplate>
        </Ajax:UpdatePanel>
    </form>
</body>
</html>
