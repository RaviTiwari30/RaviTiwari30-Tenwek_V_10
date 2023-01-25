<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewICDPatientWise.aspx.cs"
    Inherits="Design_MRD_ViewICDPatientWise" %>
    <%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, 
PublicKeyToken=31bf3856ad364e35"
Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/framestyle.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="Pbody_box_inventory" style="margin-top:0px;">
        <div class="POuter_Box_Inventory">
            <div class="">
                <div style="text-align: center;">
                    <strong>Patient Diagnosis Information ( with ICD Codes )</strong><br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center">
                    <asp:GridView ID="grvICDCode" runat="server" Width="100%" CssClass="GridViewStyle" AutoGenerateColumns="false"
                        OnRowCommand="grdDig_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="IPDNo" HeaderText="IPD No.">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ICD10_3_Code" HeaderText="Sub&nbsp;Section">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ICD10_3_Code_Desc" HeaderText="Sub Section Desc.">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="340" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ICD10_Code" HeaderText="ICD&nbsp;Code">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="WHO_Full_Desc" HeaderText="ICD Desc.">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Remove">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbRemove" runat="server" CausesValidation="false" CommandArgument='<%# Eval("TransactionID")+"#"+Eval("icd_id")+"#"+Eval("ID") %>'
                                        CommandName="imbRemove" ImageUrl="~/Images/Delete.gif" ToolTip="Click to Remove" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
               
        </div>
    </div>
    </form>
</body>
</html>
