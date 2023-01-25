<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TaxlabNew_master.aspx.cs"
    MasterPageFile="~/DefaultHome.master" EnableEventValidation="false" Inherits="Design_Payroll_TaxlabNew_master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title></title>

        <script type="text/javascript">
            function validate() {
                if (Page_IsValid) {
                    document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                    document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                    __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
                }
                else {
                    document.getElementById('<%=btnSave.ClientID%>').disabled = false;
                    document.getElementById('<%=btnSave.ClientID%>').value = 'Save';
                }
            }
            function checkForSecondDecimal(sender, e) {
                formatBox = document.getElementById(sender.id);
                strLen = sender.value.length;
                strVal = sender.value;
                hasDec = false;
                e = (e) ? e : (window.event) ? event : null;

                if (e) {
                    var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));

                    if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '.');
                            if (hasDec)
                                return false;
                        }
                    }
                }
                return true;
            }
        </script>
    </head>
    <body>
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <b>Tax Master </b>
                    <br />
                    <asp:Label ID="lblmsg" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="Red"></asp:Label>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Year
                </div>
                <table>
                    <tr>
                        <td>Year
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlyear" runat="server" OnSelectedIndexChanged="ddlyear_SelectedIndexChanged"
                                AutoPostBack="true">
                                <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                <asp:ListItem Text="2013" Value="1"></asp:ListItem>
                                <asp:ListItem Text="2014" Value="2"></asp:ListItem>
                                <asp:ListItem Text="2015" Value="3"></asp:ListItem>
                                <asp:ListItem Text="2016" Value="4"></asp:ListItem>
                                <asp:ListItem Text="2017" Value="5"></asp:ListItem>
                                <asp:ListItem Text="2018" Value="6"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="Purchaseheader">
                    Result
                </div>
                <asp:GridView ID="grd" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnRowCommand="grd_RowCommand" OnRowDataBound="grd_RowDataBound">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Year" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="lblYear" runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Income From" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:TextBox ID="txtIncomefrom" runat="server" MaxLength="10" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="flt3" runat="server" TargetControlID="txtIncomefrom"
                                    FilterType="Numbers,Custom" ValidChars=".">
                                </cc1:FilteredTextBoxExtender>
                                <asp:RequiredFieldValidator ID="reqshelf1" SetFocusOnError="true" runat="server" ControlToValidate="txtIncomefrom"
                                    ValidationGroup="doc" InitialValue="0" ErrorMessage="Please Enter Income From" Display="None"></asp:RequiredFieldValidator>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Income To">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            <ItemTemplate>
                                <asp:TextBox ID="txtIncometo" runat="server" MaxLength="10" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="flt2" runat="server" TargetControlID="txtIncometo"
                                    FilterType="Numbers,Custom" ValidChars=".">
                                </cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tax Percentage">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            <ItemTemplate>
                                <asp:TextBox ID="txtPercentage" runat="server" MaxLength="5" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="flt1" runat="server" TargetControlID="txtPercentage"
                                    FilterType="Numbers,Custom" ValidChars=".">
                                </cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tax Rate">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            <ItemTemplate>
                                <asp:TextBox ID="txtRate" runat="server" MaxLength="10" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="flt4" runat="server" TargetControlID="txtRate" FilterType="Numbers,Custom"
                                    ValidChars=".">
                                </cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnSticker" ToolTip="Sticker" runat="server" ImageUrl="../../Images/ButtonAdd.png"
                                    CommandName="Add" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Cancel">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbSelect" ToolTip="Cancel Appointment" runat="server" ImageUrl="~/Images/Delete.gif"
                                    CausesValidation="false" CommandArgument='<%# Container.DataItemIndex+1 %>' CommandName="reject" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <div class="POuter_Box_Inventory">
                <div style="vertical-align: middle; text-align: center">
                    <asp:Button ID="btnSave" ValidationGroup="save1" runat="server" CssClass="ItDoseButton"
                        OnClick="btnSave_Click" TabIndex="37" Text="Save" ToolTip="Click To Save" OnClientClick="return validate();" />
                    <%--OnClientClick="RestrictDoubleEntry(this);"--%>
                </div>
            </div>
        </div>
    </body>
    </html>
</asp:Content>