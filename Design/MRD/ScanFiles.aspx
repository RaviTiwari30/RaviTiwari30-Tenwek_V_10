<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ScanFiles.aspx.cs" Inherits="Design_MRD_ScanFiles" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script  type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="../../Scripts/Message.js"></script>
<link href="../../Styles/framestyle.css" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <%--<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />--%>
</head>
<body>
    <form id="form1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager" runat="Server" />
    <div id="Pbody_box_inventory" style="margin-top:0px;">
        <div class="POuter_Box_Inventory">
          
                <div style="text-align: center;">
                    <b>Upload &nbsp;Files</b></div>
                <div style="text-align: center;">
                    <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="ItDoseLblError" />
                </div>
          
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: right;">
                <span style="text-align: right; color: Red; float: right;">
                    <asp:Label ID="lblNote" runat="server" Text="Note : Only pdf,jpg,txt,doc,docx,csv,xls,xslx,gif file accepted."></asp:Label></span>
            </div>
            <div style="overflow: auto; padding: 3px; width: 100%; text-align:center; height: 274px;">
                <asp:GridView ID="grdUploadDocs" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                    Width="100%" OnRowCommand="grdUploadDocs_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="Document Name">
                            <ItemTemplate>
                                <asp:Label ID="rbtnupld" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Doc. Id">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblDocID" runat="server" Text='<%#Eval("ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="DocDetID" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="DocDetID" runat="server" Text='<%#Eval("FileDetID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Browse File">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:FileUpload ID="FileUpload1" runat="server" EnableTheming="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Previous File">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblUrl" runat="server" Visible='<%# Util.GetBoolean(Eval("UploadStatus")) %>'
                                    Text='<%#Eval("URL") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Upload">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Button ID="btnupload1" runat="server" Text="Upload" CommandName="UPLOAD" CommandArgument='<%# Container.DataItemIndex %>' CssClass="ItDoseButton"/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Button ID="btnView" runat="server" CommandName="VIEW" CommandArgument='<%# Container.DataItemIndex %>'
                                    Text="View" Visible='<%# Util.GetBoolean(Eval("UploadStatus")) %>' CssClass="ItDoseButton"/></td>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
