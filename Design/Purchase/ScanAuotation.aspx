<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="ScanAuotation.aspx.cs" Inherits="Design_Purchase_ScanAuotation"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
                    <b>Upload Files</b><br />
               
                    <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <table style="width:100%">
                    <tr>
                        <td style="text-align: right; width: 25%;">
                            Quotation&nbsp;Perfoma&nbsp;No. :
                        </td>
                        <td style="text-align: left; width: 25%;">
                            <asp:TextBox ID="txtQuotationNo" runat="server" Width="187px" ></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 10%;">
                            Vendor :
                        </td>
                        <td style="text-align: left; width: 40%;">
                            <asp:DropDownList ID="ddlVendor" runat="server" Width="200px" CssClass="ItDoseLabel">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 25%;">
                        </td>
                        <td style="text-align: right; width: 25%;">
                            <asp:DropDownList ID="ddlcategory" runat="server" Width="200px" Visible="False" CssClass="ItDoseLabel">
                            </asp:DropDownList>
                        </td>
                        <td style="text-align: right; width: 10%;">
                        </td>
                        <td style="text-align: right; width: 40%;">
                            <asp:DropDownList ID="ddlSubCategory" runat="server" Width="200px" Visible="False"
                                CssClass="ItDoseLabel">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 25%;">
                        </td>
                        <td style="text-align: right; width: 25%;">
                            <asp:DropDownList ID="ddlItem" runat="server" Width="200px" Visible="False" CssClass="ItDoseLabel">
                            </asp:DropDownList>
                        </td>
                        <td style="text-align: right; width: 10%;">
                        </td>
                        <td style="text-align: right; width: 40%;">
                        </td>
                    </tr>
                  <tr>
                        <td colspan="4" style="text-align: center;">
                            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                                CssClass="ItDoseButton" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content">
            <span style="text-align:right; color:Red; float: right;">
            <asp:Label ID="lblNote" runat="server" Text="Note : Only pdf,jpg,txt,doc,docx,csv,xls,xslx,gif file accepted."></asp:Label></span>
                <asp:GridView ID="grdUploadDocs" runat="server" AutoGenerateColumns="false" Width="954px"
                    OnRowCommand="grdUploadDocs_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="Vendor">
                            <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            <ItemTemplate>
                                <asp:Label ID="lblVenName" runat="server" Text='<%#Eval("VendorName") %>'></asp:Label>
                                <asp:Label ID="lblvendorid" runat="server" Text='<%#Eval("VendorID") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Performa No.">
                            <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemTemplate>
                                <asp:Label ID="lblQuotRefNo" runat="server" Text='<%#Eval("QuotationRefNo") %>'></asp:Label>
                                <asp:Label ID="lblRefNo" runat="server" Text='<%#Eval("RefrenceNo") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Performa Date">
                            <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemTemplate>
                                <asp:Label ID="lblRefDate" runat="server" Text='<%#Eval("RefDate") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Browse File">
                            <ItemStyle CssClass="GridViewItemStyle" Width="300px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                            <ItemTemplate>
                                <asp:FileUpload ID="FileUpload1" runat="server" Width="266px" EnableTheming="false"></asp:FileUpload>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Previous File">
                            <ItemStyle CssClass="GridViewItemStyle" Width="300px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                            <ItemTemplate>
                                <asp:Label ID="lblUrl" runat="server" Visible='<%# Util.GetBoolean(Eval("UploadStatus")) %>'
                                    Text='<%#Eval("URL") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Upload">
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                            <%--Visible='<%# !Util.GetBoolean(Eval("UploadStatus")) %>'--%>
                                <asp:Button ID="btnUpload" runat="server" 
                                    Text="Upload" CommandName="UPLOAD" CommandArgument='<%# Container.DataItemIndex %>' CssClass="ItDoseButton"/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View">
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
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
</asp:Content>
