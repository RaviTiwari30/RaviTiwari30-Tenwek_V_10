<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="IPD_PatientIssueDetails.aspx.cs" Inherits="Design_Store_IPD_PatientIssueDetails" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/Message.js" type="text/javascript" ></script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
        EnableScriptGlobalization="true" EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>IPD Patient Medical Issue Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
   
    <div class="POuter_Box_Inventory" >
        <div class="Purchaseheader">
            Report Criteria
        </div>
        <div>
            <table style=" width:100%">
                <tr>
                    <td style="width: 20%;text-align:right">
                        IPD No. :&nbsp;
                    </td>
                    <td style="width: 20%">
                        <asp:TextBox ID="txtCRNo" MaxLength="10" runat="server"  ToolTip="Enter IPD No." TabIndex="1" Width="125px"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        
                    </td>
                    <td style="width: 20%;text-align:right">
                       Patient Name :&nbsp;
                    </td>
                    <td style="width: 20%">
                        <asp:TextBox ID="txtName" MaxLength="50" TabIndex="2" ToolTip="Enter Patient Name" runat="server" Width="200px"></asp:TextBox>
                    </td>
                    <td style="width: 20%">
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="POuter_Box_Inventory" style="text-align: center">
        <asp:Button ID="btnSearchByName"  CssClass="ItDoseButton" runat="server" OnClick="btnSearchByName_Click"
            Text="Search" ValidationGroup="oth" />&nbsp;
    </div>
    <div class="POuter_Box_Inventory">
        <asp:GridView ID="gvPatientDetail" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
            OnRowCommand="gvPatientDetail_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="S.No.">
                    <ItemStyle CssClass="GridViewItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                    <ItemTemplate>
                        <%# Container.DataItemIndex+1 %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Patient Name">
                    <ItemStyle CssClass="GridViewItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                    <ItemTemplate>
                        <%# Eval("Name")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="IPD No.">
                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                    <ItemTemplate>
                        
                        <asp:Label ID="lblTransactionID" runat="server" Text='<%#Util.GetString(Eval("TransactionID")).Replace("ISHHI","") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Age">
                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    <ItemTemplate>
                        <%# Eval("Age")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Sex">
                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                    <ItemTemplate>
                        <%# Eval("Gender")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Panel">
                    <ItemStyle CssClass="GridViewItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                    <ItemTemplate>
                        <%# Eval("Company_Name")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Date&nbsp;Of&nbsp;Admit">
                    <ItemStyle CssClass="GridViewItemStyle"  HorizontalAlign="Center"/>
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    <ItemTemplate>
                        <%# Eval("DateOfAdmit")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="View">
                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                    <ItemTemplate>
                        <asp:ImageButton ID="imgSelect" ImageUrl="~/Images/view.GIF" CommandArgument='<%#Eval("TransactionID") %>'
                            runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtCRNo"
        Display="None" ErrorMessage="Enter IPD No." SetFocusOnError="True" ValidationGroup="Search">*</asp:RequiredFieldValidator>
    </div>
</asp:Content>
