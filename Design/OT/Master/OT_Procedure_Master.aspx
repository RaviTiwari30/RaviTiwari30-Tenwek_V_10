<%@ Page Language="C#" ValidateRequest="false" EnableEventValidation="false" AutoEventWireup="true"
    MaintainScrollPositionOnPostback="true" CodeFile="OT_Procedure_Master.aspx.cs" Inherits="Design_OT_MASTER_OT_Procedure_Master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <script src="../../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <link href="../../../Styles/framestyle.css" rel="stylesheet" />
    <link href="../../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            $("#txtDetail").keypress(function (e) {
                if (e.which == 35) {
                    return false;
                }
            });
        });
    </script>

</head>
<body>
    <form id="form1" runat="server">

        <div id="Pbody_box_inventory" style="margin-top:0px;width:1030px;">
            <Ajax:ScriptManager ID="ScriptManager" runat="Server" />
            <div class="POuter_Box_Inventory" style="text-align: center;">


                <b>OT Procedure Header Master
                </b>
                <br />


                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />


            </div>
            <div class="POuter_Box_Inventory">


                <div class="Purchaseheader">
                    Procedure Details 
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Header
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlHeader" runat="server" AutoPostBack="True"
                                    OnSelectedIndexChanged="ddlHeader_SelectedIndexChanged" TabIndex="1">
                                    <asp:ListItem Value="Procedure">Procedure</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Template
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlTemplates" runat="server" TabIndex="2" AutoPostBack="True"
                                    OnSelectedIndexChanged="ddlTemplates_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-5">
                                <asp:Button ID="btnNewProcedure" runat="server" CausesValidation="False" CssClass="ItDoseButton"
                                    Text="Add New Procedure" OnClick="btnNewProcedure_Click" />
                            </div>
                        </div>
                         <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Template Text
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                             <CKEditor:CKEditorControl ID="txtDetail" BasePath="~/ckeditor" runat="server" EnterMode="BR" TabIndex="26"></CKEditor:CKEditorControl>
                        </div>
                    </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <table style="width: 100%">
                    <tr>

                        <td style="text-align: right">
                            <asp:Label runat="server" ID="lbltemplateheader" Text="Template Header :&nbsp;"></asp:Label>
                        </td>
                        <td style="width: 50%; text-align: left">
                            <asp:TextBox ID="txtTempHeader" runat="server" Width="191px" TabIndex="3"></asp:TextBox>
                            <asp:TextBox ID="txtID" runat="server"></asp:TextBox>

                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" CausesValidation="False" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click" TabIndex="4" />
                <asp:Button ID="btnUpdate" runat="server" CausesValidation="False" CssClass="ItDoseButton" Text="Update" OnClick="btnUpdate_Click" TabIndex="4" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Procedure Details List&nbsp;
                
                </div>
                <div style="text-align: center;">
                    <asp:GridView ID="grdHeader" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        PageSize="5" Width="60%" OnRowCommand="grdHeader_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Header Added">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="500px" HorizontalAlign="Left" />
                                <ItemTemplate>
                                    <asp:Label ID="lblheader" runat="server" Text='<%#Eval("HeaderName")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    &nbsp;<asp:ImageButton ID="imbModify" runat="server" CausesValidation="false" CommandArgument='<%# Eval("ID") %>'
                                        CommandName="AEdit" ImageUrl="~/Images/edit.png" ToolTip="Modify Item" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Delete">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    &nbsp;<asp:ImageButton ID="imbDelete" runat="server" CausesValidation="false" CommandArgument='<%# Eval("ID") %>'
                                        CommandName="ADelete" ImageUrl="~/Images/Delete.gif" ToolTip="Delete Item" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    </asp:GridView>
                </div>
            </div>

        </div>

    </form>
</body>
</html>
