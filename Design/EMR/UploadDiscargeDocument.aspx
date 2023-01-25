<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UploadDiscargeDocument.aspx.cs" Inherits="Design_EMR_UploadDiscargeDocument" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript">
        function validate() {
            if ($('#FileUpload1').val() == "") {
                $('#fileUpload1').focus();
                $('#lblMsg').text('Please Browse File');
                return false;

            }
            if ($('#txtWidth').val() == "") {
                $('#txtWidth').focus();
                $('#lblMsg').text('Please Enter Width');
                return false;

            }
            if ($('#txtWidth').val() > "21") {
                $('#lblMsg').text('Maximum Image Width 21 cm. ');
                $('#txtWidth').focus();
                return false;
            }
            if ($('#txtHeight').val() == "") {
                $('#txtHeight').focus();
                $('#lblMsg').text('Please Enter Height');
                return false;
            }
            if ($('#txtHeight').val() > "16") {
                $('#lblMsg').text('Maximum Image Height 16 cm. ');
                $('#txtHeight').focus();
                return false;
            }
        }

        $(document).ready(function () {
            $('#txtWidth').bind("keyup", function () {

                if ($(this).val() > "21") {
                    $('#lblMsg').text('Maximum Image Width 21 cm. ');
                    $('#btnSave').prop('disabled', 'disabled');
                    return false;
                }
                else {
                    $('#lblMsg').text('');
                    $('#btnSave').removeProp('disabled');
                }
            });

            $('#txtHeight').bind("keyup", function () {
                if ($(this).val() > "16") {
                    $('#lblMsg').text('Maximum Image Width 16 cm. ');
                    $('#btnSave').prop('disabled', 'disabled');
                    return false;
                }
                else {
                    $('#lblMsg').text('');
                    $('#btnSave').removeProp('disabled');
                }
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">

        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="ScriptManager" runat="Server" />
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Upload Discharge Document(Only PDF Upload)</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader"></div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Update  Image 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:FileUpload ID="FileUpload1" ClientIDMode="Static" runat="server" />
                            </div>
                            <div class="col-md-3" style="display:none">
                                <label class="pull-left">
                                    Narration
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="display:none">
                                <asp:TextBox ID="txtNarration" runat="server" MaxLength="100"></asp:TextBox>
                            </div>
                            <div class="col-md-2" style="display:none">
                                <label class="pull-left">
                                    Width
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2"style="display:none">
                                <asp:TextBox ID="txtWidth" AutoCompleteType="Disabled" Text="21" ClientIDMode="Static" MaxLength="2" runat="server" Width="40px">
                                </asp:TextBox>&nbsp;px
                            </div>
                            <div class="col-md-2"style="display:none">
                                <label class="pull-left">
                                    Height
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2" style="display:none">
                                <asp:TextBox ID="txtHeight" AutoCompleteType="Disabled" ClientIDMode="Static" MaxLength="2" Text="16" runat="server" Width="40px">

                                </asp:TextBox>&nbsp;px
                            <cc1:FilteredTextBoxExtender ID="ftbWidth" runat="server" TargetControlID="txtWidth" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                <cc1:FilteredTextBoxExtender ID="ftbHeight" runat="server" TargetControlID="txtHeight" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-11"></div>
                            <div class="col-md-4">
                                <asp:Button ID="btnSave" ClientIDMode="Static" runat="server" OnClientClick="return validate()" CssClass="ItDoseButton" Text="Save Image" OnClick="btnSave_Click" />
                            </div>
                            <div class="col-md-9"></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Uploaded Images</div>

                <asp:GridView ID="grvImages" runat="server" AutoGenerateColumns="False"
                    CssClass="GridViewStyle" OnRowCommand="grvImages_RowCommand"
                    OnRowEditing="grvImages_RowEditing"
                    OnRowCancelingEdit="grvImages_RowCancelingEdit"
                    OnRowUpdating="grvImages_RowUpdating">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %><asp:Label ID="lblID" runat="server" Text='<%#Eval("id") %>' Style="display: none;"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Images">
                            <ItemTemplate>
                                <%--<asp:Image ID="Image1" ImageUrl='<%#Eval("imgUrl") %>' runat="server" Width="300px" CommandName="aView" CommandArgument='<%#Eval("imgUrl") %>'   />--%>
                                <asp:ImageButton  ImageUrl="~/Images/view.GIF" ID="ibView" CommandName="aView" CommandArgument='<%#Eval("imgUrl") %>' runat="server"></asp:ImageButton>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Narration" Visible="false">
                            <ItemTemplate>
                                <%#Eval("OtImageNarration") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtNarration" Text='<%# Eval("OtImageNarration") %>'
                                    runat="server" MaxLength="20"></asp:TextBox>
                            </EditItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" Width="160px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Priority" Visible="false">
                            <ItemTemplate>
                                <%#Eval("Priority")%>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtPriority" Width="30" Text='<%#Eval("Priority")%>' runat="server" MaxLength="2"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender runat="server" ID="febePriority" TargetControlID="txtPriority" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                            </EditItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Photo Width" Visible="false">
                            <ItemTemplate>
                                <%#Eval("PhotoWidth")%>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtwidth" Width="30" Text='<%#Eval("PhotoWidth")%>' runat="server" MaxLength="2"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender runat="server" ID="febewidth" TargetControlID="txtwidth" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                            </EditItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Photo Heigth" Visible="false">
                            <ItemTemplate>
                                <%#Eval("PhotoHeight")%>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtHeight" Width="30" Text='<%#Eval("PhotoHeight")%>' runat="server" MaxLength="2"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender runat="server" ID="febeHeight" TargetControlID="txtHeight" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                            </EditItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit" Visible="false">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbEdit" runat="server" CommandName="Edit" Text="Edit">Edit</asp:LinkButton>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:LinkButton ID="lbkUpdate" runat="server" CausesValidation="True" CommandName="Update" Text="Update"></asp:LinkButton>
                                <asp:LinkButton ID="lnkCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                            </EditItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Delete">
                            <ItemTemplate>
                                <asp:ImageButton AlternateText="delete" ImageUrl="~/Images/Delete.gif" ID="ibRemove" CommandName="imgRemove" CommandArgument='<%#Eval("OtImage") %>' runat="server"></asp:ImageButton>
                            </ItemTemplate>
                            <EditItemTemplate>
                            </EditItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>



                    </Columns>
                </asp:GridView>

            </div>
        </div>
    </form>
</body>
</html>
