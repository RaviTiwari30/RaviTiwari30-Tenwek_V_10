<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewuploadedDocuments.aspx.cs"
    Inherits="Design_CPOE_ViewuploadedDocuments" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <%--<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />--%>
    <script language="javascript" src="../../Scripts/Message.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>Document History</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Documents
                </div>
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnRowCommand="GridView1_RowCommand" OnRowDataBound="GridView1_RowDataBound">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Research Form">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                            <ItemTemplate>
                                <asp:Label ID="lblStatus" runat="server" Visible="false" Text='<%# Eval("STATUS") %>' />
                                <asp:Label ID="lblTypeID" runat="server" Text='<%#Eval("FormID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblID" runat="server" Text='<%#Eval("ID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblName" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Upload">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:FileUpload ID="ddlupload_doc" runat="server" />
                                <asp:Label ID="lblFilePath" Visible="false" runat="server" Text='<%#Eval("Url") %>'></asp:Label>
                                <asp:Label ID="lblFileName" Visible="false" runat="server" Text='<%#Eval("Imagename") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Remarks">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="230px" />
                            <ItemTemplate>
                                <asp:TextBox ID="txtRemarkDocument" runat="server" Text='<%#Eval("Remark") %>'></asp:TextBox>
                                <asp:ImageButton ID="imgUpdateRemark" runat="server" ImageUrl="~/Images/Post.gif" ToolTip="Update Remark"
                                    CommandArgument='<%#Container.DataItemIndex%>' CommandName="UpdateRemark" Enabled='<%# Util.GetBoolean(Eval("Status")) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Upload Date">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemTemplate>
                                <asp:Label ID="lblUploadDate" runat="server" Text='<%#Eval("Upload_Date") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Upload Time">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemTemplate>
                                <asp:Label ID="lblUploadTime" runat="server" Text='<%#Eval("Upload_Time") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:Label ID="lblVisible" runat="server" Text='<%#Eval("visible") %>' Visible="false"></asp:Label>
                                <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                    Enabled='<%# Util.GetBoolean(Eval("FileStatus")) %>' ToolTip="Click To View Available Document"
                                    ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("Url")  %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <div style="text-align: center">
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" ToolTip="Click to Upload" Text="Upload" OnClick="btnSave_Click" />
            </div>

            <div class="Purchaseheader">
                Uploaded Documents
            </div>
            <asp:GridView ID="grdDocDetails" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                OnRowCommand="grdDocDetails_RowCommand" Style="text-align: center"
                OnRowDataBound="grdDocDetails_RowDataBound">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Research Form">
                        <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="400px" />
                        <ItemTemplate>
                            <asp:Label ID="lblTypeID" runat="server" Text='<%#Eval("FormID") %>' Visible="false"></asp:Label>
                            <asp:Label ID="lblName" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Remark">
                        <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="400px" />
                        <ItemTemplate>
                            <asp:Label ID="lbluploadedRemark" runat="server" Text='<%#Eval("Remark") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Upload Date">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                        <ItemTemplate>
                            <asp:Label ID="lblviewUploadDate" runat="server" Text='<%#Eval("Upload_Date") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Upload Time">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                        <ItemTemplate>
                            <asp:Label ID="lblviewUploadTime" runat="server" Text='<%#Eval("Upload_Time") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="View">
                        <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        <ItemTemplate>
                            <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                ToolTip="Click To View Available Document" ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("Url")  %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        </div>
    </form>
</body>
</html>
