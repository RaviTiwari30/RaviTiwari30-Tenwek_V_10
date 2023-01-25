<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OxygenRecord1.aspx.cs" Inherits="Design_IPD_OxygenRecord1" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <script type="text/javascript">
        function validate() {
            $("#btnSave").val('Submitting...').attr('disabled', 'disabled');
            __doPostBack('btnSave', '');

            return true;
        }
    </script>

    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Ventilator Input/Output Chart </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                <asp:Label ID="lblID" runat="server" CssClass="ItDoseLblError" Visible="false" />
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <table style="width: 100%;">
                    <tr>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black" class="left-align" colspan="8">
                            <strong>Operator Input</strong>
                        </td>
                    </tr>
                    <tr>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black" rowspan="2"><strong>Ventilator Setting</strong></td>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black">IP (cm H2O)</td>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black">PIP (cm H2O)</td>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black">PEEP (cm H2O)</td>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black" rowspan="2"><strong>Pressure Support</strong></td>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black">IP (cm H2O)</td>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black">PIP (cm H2O)</td>
                        <td style="border: 1px; border-bottom: solid black;">PEEP (cm H2O)</td>
                    </tr>
                    <tr>
                        <td style="border-right: solid black; border-left-style: none; border-left-color: inherit; border-left-width: 1px; border-top-style: none; border-top-color: inherit; border-top-width: 1px; border-bottom-style: none; border-bottom-color: inherit; border-bottom-width: 1px; margin-left: 40px;">
                            <asp:TextBox ID="txtOI_VS_IP" Width="100px" runat="server"></asp:TextBox>
                        </td>
                        <td style="border: 1px; border-right: solid black">
                            <asp:TextBox ID="txtOI_VS_PIP" Width="100px" runat="server"></asp:TextBox>
                        </td>
                        <td style="border: 1px; border-right: solid black">
                            <asp:TextBox ID="txtOI_VS_PEEP" Width="100px" runat="server"></asp:TextBox>
                        </td>
                        <td style="border: 1px; border-right: solid black">
                            <asp:TextBox ID="txtOI_PS_IP" Width="100px" runat="server"></asp:TextBox>
                        </td>
                        <td style="border: 1px; border-right: solid black">
                            <asp:TextBox ID="txtOI_PS_PIP" Width="100px" runat="server"></asp:TextBox>
                        </td>
                        <td>
                            <asp:TextBox ID="txtOI_PS_PEEP" Width="100px" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black" class="left-align" colspan="8">
                            <strong style="text-align: left">Database Output</strong>
                        </td>
                    </tr>
                    <tr>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black" rowspan="2"><strong>Ventilator Setting</strong></td>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black">IP (cm H2O)</td>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black">PIP (cm H2O)</td>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black">PEEP (cm H2O)</td>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black" rowspan="2"><strong>Pressure Support</strong></td>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black">IP (cm H2O)</td>
                        <td style="border: 1px; border-bottom: solid black; border-right: solid black">PIP (cm H2O)</td>
                        <td style="border: 1px; border-bottom: solid black;">PEEP (cm H2O)</td>
                    </tr>
                    <tr>
                        <td style="border: 1px; border-right: solid black">
                            <asp:TextBox ID="txtDO_VS_IP" Width="100px" runat="server"></asp:TextBox>
                        </td>
                        <td style="border: 1px; border-right: solid black">
                            <asp:TextBox ID="txtDO_VS_PIP" Width="100px" runat="server"></asp:TextBox>
                        </td>
                        <td style="border: 1px; border-right: solid black">
                            <asp:TextBox ID="txtDO_VS_PEEP" Width="100px" runat="server"></asp:TextBox>
                        </td>
                        <td style="border: 1px; border-right: solid black">
                            <asp:TextBox ID="txtDO_PS_IP" Width="100px" runat="server"></asp:TextBox>
                        </td>
                        <td style="border: 1px; border-right: solid black">
                            <asp:TextBox ID="txtDO_PS_PIP" Width="100px" runat="server"></asp:TextBox>
                        </td>
                        <td>
                            <asp:TextBox ID="txtDO_PS_PEEP" Width="100px" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <table style="width: 100%">
                    <tr>
                        <td style="text-align: center; width: 100%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align: center; width: 100%">
                            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="btnSave_Click" OnClientClick="return validate(this);" />
                            <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="ItDoseButton" OnClick="btnUpdate_Click" Visible="false" />
                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" OnClick="btnCancel_Click" Visible="false" />
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="height: 19px; overflow: auto;">
                    Results
                </div>
                <div style="overflow: auto; overflow-y: auto; padding: 3px; height: 274px;">
                    <asp:GridView ID="grdVentilatorChart" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdVentilatorChart_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                    <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px"></HeaderStyle>
                                <ItemStyle CssClass="GridViewItemStyle" Width="20px" HorizontalAlign="Center"></ItemStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblDate" runat="server" Text='<%#Eval("Date") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Time">
                                <ItemTemplate>
                                    <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="OI VS IP">
                                <ItemTemplate>
                                    <asp:Label ID="lblOI_VS_IP" runat="server" Text='<%#Eval("OI_VS_IP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="OI VS PIP">
                                <ItemTemplate>
                                    <asp:Label ID="lblOI_VS_PIP" runat="server" Text='<%#Eval("OI_VS_PIP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="OI VS PEEP">
                                <ItemTemplate>
                                    <asp:Label ID="lblOI_VS_PEEP" runat="server" Text='<%#Eval("OI_VS_PEEP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="OI PS IP">
                                <ItemTemplate>
                                    <asp:Label ID="lblOI_PS_IP" runat="server" Text='<%#Eval("OI_PS_IP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="OI PS PIP">
                                <ItemTemplate>
                                    <asp:Label ID="lblOI_PS_PIP" runat="server" Text='<%#Eval("OI_PS_PIP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="OI PS PEEP">
                                <ItemTemplate>
                                    <asp:Label ID="lblOI_PS_PEEP" runat="server" Text='<%#Eval("OI_PS_PEEP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="DO VS IP">
                                <ItemTemplate>
                                    <asp:Label ID="lblDO_VS_IP" runat="server" Text='<%#Eval("DO_VS_IP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="DO VS PIP">
                                <ItemTemplate>
                                    <asp:Label ID="lblDO_VS_PIP" runat="server" Text='<%#Eval("DO_VS_PIP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="DO VS PEEP">
                                <ItemTemplate>
                                    <asp:Label ID="lblDO_VS_PEEP" runat="server" Text='<%#Eval("DO_VS_PEEP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="DO PS IP">
                                <ItemTemplate>
                                    <asp:Label ID="lblDO_PS_IP" runat="server" Text='<%#Eval("DO_PS_IP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="DO PS PIP">
                                <ItemTemplate>
                                    <asp:Label ID="lblDO_PS_PIP" runat="server" Text='<%#Eval("DO_PS_PIP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="DO PS PEEP">
                                <ItemTemplate>
                                    <asp:Label ID="lblDO_PS_PEEP" runat="server" Text='<%#Eval("DO_PS_PEEP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Entry By">
                                <ItemTemplate>
                                    <asp:Label ID="lblEntryBy" runat="server" Text='<%#Eval("CreatedBy") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
