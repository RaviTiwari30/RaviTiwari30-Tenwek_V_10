<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewUploadDocument.aspx.cs" Inherits="Design_IPD_ViewUploadDocument" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/Common.js" type="text/javascript"></script>


    <script type="text/javascript">
        $(function () {
            $('#grdDocDetails input[type=file]').change(function (e) {
                var fileSize = this.files[0].size / 1024 / 1024;
                if (fileSize > 10) {
                    this.value = '';
                    modelAlert('File size should be less than 10 MB');
                }
            });
        });

    </script>
</head>
<body>

    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <ajax:ScriptManager ID="ScriptManager1" runat="server"></ajax:ScriptManager>
                <b>Upload Patient Documents</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <span
                    style="background-color: LightGreen">Document Uploaded</span>
                <span style="background-color: LightPink">Document Not Uploaded</span>
                <br />
                <asp:Label ID="lblNote" runat="server" CssClass="ItDoseLblError" Text="Note : Only jpg,word,pdf,excel file accepted."></asp:Label>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Search Criteria
                </div>
                <br />
                <em style="color: blue">Note : Change Date to View Document or Select Uploaded Document </em>
                <table>
                    <tr>
                        <td style="width: 500px">
                            <asp:RadioButtonList ID="rdbDocument" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" CssClass="ItDoseRadiobuttonlist" OnSelectedIndexChanged="rdbDocument_SelectedIndexChanged">
                                <asp:ListItem Value="0" Selected="True">Upload Document</asp:ListItem>
                                <asp:ListItem Value="1">Uploaded Document</asp:ListItem>
                            </asp:RadioButtonList></td>
                        <td>Upload Document Date :&nbsp;</td>
                        <td style="text-align: center">
                            <asp:TextBox ID="txtDocumentDate" runat="server" OnTextChanged="txtDocumentDate_TextChanged" AutoPostBack="true" Width="100px"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtDocumentDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </td>

                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory">
                <asp:GridView Width="100%" ID="grdDocDetails" runat="server" ClientIDMode="Static" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdDocDetails_RowCommand" OnRowDataBound="grdDocDetails_RowDataBound">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Upload Date">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" HorizontalAlign="Center" />
                            <ItemTemplate>

                                <asp:Label ID="lbluploadDate" Text='<%#Eval("DocumentDate")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Form Name">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                            <ItemTemplate>
                                <asp:Label ID="lblID" runat="server" Text='<%#Eval("ID")%>' Visible="false"></asp:Label>
                                <asp:Label ID="lblName" Text='<%#Eval("Name")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:FileUpload ID="ddlupload_doc" runat="server" />
                                <asp:Label ID="lblStatus" runat="server" Visible="false" Text='<%# Eval("Status") %>' />
                                <asp:Label ID="lblFilePath" Visible="false" Text='<%#Eval("Url") %>' runat="server"></asp:Label>
                                <asp:Label ID="lblFileName" Visible="false" Text='<%#Eval("ImageName") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Remarks">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                            <ItemTemplate>
                                <table>
                                    <tr>
                                        <td>
                                            <asp:TextBox ID="txtRemark" runat="server" Text='<%#Eval("Remark") %>'></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:ImageButton ID="imgUpdateRemark" runat="server" ImageUrl="~/Images/Post.gif"
                                                CommandArgument='<%#Container.DataItemIndex +1%>' CommandName="UpdateRemark" Enabled='<%# Util.GetBoolean(Eval("Status")) %>' />
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            <ItemTemplate>
                                <asp:Label ID="lblVisible" Text='<%#Eval("visible") %>' runat="server" Visible="false"></asp:Label>
                                <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView" ToolTip="Click To View Available Document" Enabled='<%# Util.GetBoolean(Eval("Status")) %>' ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("Url")  %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>



            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:TextBox ID="txtuploadDate" runat="server" Width="100px"></asp:TextBox>
                <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="txtuploadDate" Format="dd-MMM-yyyy"
                    Animated="true" runat="server">
                </cc1:CalendarExtender>
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" ToolTip="Click to Upload"
                    Text="Upload" OnClick="btnSave_Click" />
            </div>
        </div>
    </form>
</body>
</html>
