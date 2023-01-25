<%@ Page Language="C#" ValidateRequest="false" ClientIDMode="Static" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" CodeFile="AttendentPassReprint.aspx.cs" Inherits="Design_IPD_AttendentPassReprint" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function validateIPDNo() {
            if ($.trim($("#txtIPDNo").val()) == "") {
                $("#lblMsg").text('Please Enter IPD No.');
                $("#txtIPDNo").focus();
                return false;
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Gate Pass Print</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />&nbsp;              
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                <tr>
                    <td style="width: 15%; text-align: right">IPD No. :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <asp:TextBox ID="txtIPDNo" runat="server" AutoCompleteType="Disabled" style="Width:100px;"
                            ToolTip="Enter IPD No." TabIndex="1" MaxLength="10"></asp:TextBox>
                        <span style="color: red; font-size: 10px;"  class="shat">*</span>&nbsp;&nbsp;&nbsp; <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="2"
                Text="Search" OnClick="btnSearch_Click" OnClientClick="return validateIPDNo()" />
                        
                    </td>
                    <td style="width: 15%; text-align: right" class="ItDoseLabel">&nbsp;</td>
                    <td style="width: 35%; text-align: left"></td>
                </tr>
               
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Patient Details 
            </div>
            <div style="overflow: auto; padding: 3px; width: 952px; height: 274px;">
                <asp:GridView ID="grdPatient" runat="server" AutoGenerateColumns="False" Width="940px"
                    CssClass="GridViewStyle" OnRowCommand="grdPatient_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="IPD No.">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblMRNo" Text='<%#Util.GetString(Eval("TransactionID")).Replace("ISHHI","") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Name">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblPName" Text='<%# Eval("PName") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="RelativeName" HeaderText="Relative Name">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Address" HeaderText="Address">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Name" HeaderText="Case Type">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Bed_No" HeaderText="Bed No.">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="PassReprint" Visible="true">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imgPass" ToolTip="Pass" runat="server" ImageUrl="~/Images/print.gif" CausesValidation="false" CommandArgument='<%# Eval("TransactionID")%>' CommandName="Pass" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>
