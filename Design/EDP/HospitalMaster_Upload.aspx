<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="HospitalMaster_Upload.aspx.cs" Inherits="Design_EDP_HospitalMaster_Upload" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<script src="../../Scripts/jquery.blockUI.js" type="text/javascript"></script>--%>

    <script type="text/javascript">
        var blockUIOnRequest = function () {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_beginRequest(function () {
                $modelBlockUI();
            });
            prm.add_endRequest(function () {
                $modelUnBlockUI();
                MarcTooltips.add(".customTooltip", "", { position: "up", align: "left", mouseover: true });
                $('#dvgv').customFixedHeader();
            });
        }
        $(document).ready(function () {
            blockUIOnRequest();
        });
        
    </script>
    <Ajax:ScriptManager ID="sm" runat="server" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Upload Master Excels </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%">
                <tr>
                    <td>
                        <span style="background-color: lightgreen">File Uploaded</span> <span style="background-color: pink">File Not Uploaded</span></td>
                    <td style="text-align: right">
                        <asp:Label ID="lblNote" runat="server" CssClass="ItDoseLblError" Text="Note : Only Excel file accepted."></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" id="dvgv">

                        <asp:GridView Width="100%" ID="grdDocDetails" runat="server" AutoGenerateColumns="False"
                            OnRowCommand="grdDocDetails_RowCommand" OnRowDataBound="grdDocDetails_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Excel Type">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="400px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblID" runat="server" Text='<%#Eval("ID")%>' Visible="false"></asp:Label>
                                        
                                        <asp:Label ID="lblName" Text='<%#Eval("ExcelType")%>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:FileUpload ID="ddlupload_doc" runat="server"/>
                                        <asp:Label ID="lblIsUploaded" runat="server" Text='<%#Eval("IsUploaded") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:Button ID="btnSave" runat="server" CommandName="aSave" CommandArgument='<%#Eval("ExcelType")%>' Text="Upload & Save" class="ItDoseButton"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Sample Sheet">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                            ToolTip="Click To View Available Document"
                                            ImageUrl="~/Images/excelexport.gif" Width="20px" CommandArgument='<%# Eval("ExcelUrl")%>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right" colspan="2">Important: Please Upload &amp; Save the excel sheet one by one</td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>

