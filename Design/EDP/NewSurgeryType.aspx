<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NewSurgeryType.aspx.cs" MasterPageFile="~/DefaultHome.master"
    Inherits="Design_NewSurgeryType" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <div id="Pbody_box_inventory">
        <ajax:ScriptManager ID="scriptmanager" runat="server">
        </ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>New Surgery Type</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Surgery Type Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSurgeryTypeName" MaxLength="20" runat="server"  CssClass="required"></asp:TextBox>
                            <%--<asp:Label ID="Label10" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>--%>
                        </div>
                        
                        <div class="col-md-10">
                            <label class="pull-left">
                                <asp:Label ID="lblTotalShare" runat="server" Text="IS This Item Is  Base Item For  Calculating Total Surgery Amount?"></asp:Label>
                            </label>
                        </div>
                        <div class="col-md-3">
                            <asp:RadioButtonList ID="rbtnBaseItem" runat="server" RepeatDirection="Horizontal"
                                OnSelectedIndexChanged="rbtnBindDoctorList_SelectedIndexChanged">
                                <asp:ListItem Value="1">YES</asp:ListItem>
                                <asp:ListItem Selected="true" Value="0">NO</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Share In Total Surgery
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtShareInTotalSurgery" runat="server" MaxLength="20" CssClass="required"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtShareInTotalSurgery"
                                FilterType="Numbers">
                            </cc1:FilteredTextBoxExtender>
                            <%--<asp:Label ID="Label11" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>--%>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblIsThisDoc" runat="server" Text="Is This Doctor"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:RadioButtonList ID="rbtnBindDoctor" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="1">YES</asp:ListItem>
                                <asp:ListItem Value="0">NO</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Sequence&nbsp; Number
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSequenceNumber" MaxLength="4" runat="server" CssClass="required" ></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtSequenceNumber"
                                FilterType="Numbers">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table>
                <tr style="display: none">
                    <td style="width: 300px; text-align: right">
                        <asp:Label ID="lblNetShareOfDoc" runat="server" Text="Net Share Of Doctor :&nbsp;"></asp:Label>
                    </td>
                    <td colspan="2" style="height: 18px; text-align: left">
                        <asp:TextBox ID="txtNetShareDoc" MaxLength="20" runat="server" Width="150px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtNetShareDoc"
                            FilterType="Numbers">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="width: 300px; height: 18px"></td>
                </tr>
            </table>

        </div>
        <div class="POuter_Box_Inventory">
            <div  style="text-align: center">
                <asp:Button ID="btnSave" CssClass="ItDoseButton" runat="server" OnClick="btnSave_Click" Text="Save" />
            </div>
        </div>
        <asp:GridView ID="grdSearch" runat="server" Width="100%" OnSelectedIndexChanged="grdSearch_SelectedIndexChanged1"
            OnRowDataBound="grdSearch_RowDataBound" OnRowCancelingEdit="grdSearch_RowCancelingEdit"
            OnRowUpdating="grdSearch_RowUpdating" AutoGenerateColumns="False" OnRowEditing="grdSearch_RowEditing" HeaderStyle-CssClass="GridViewHeaderStyle" >
            <Columns>
                <asp:TemplateField HeaderText="S.No.">
                    <ItemTemplate>
                        <%#Container.DataItemIndex+1 %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="TypeName">
                    <ItemTemplate>
                        <asp:TextBox ID="txtName" runat="server" Text='<%# Bind("TypeName") %>'></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="MinLimit">
                    <ItemTemplate>
                        <asp:TextBox ID="txtMinLimit" runat="server" Text='<%# Bind("MinLimit") %>'></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtMinLimit"
                            FilterType="Numbers">
                        </cc1:FilteredTextBoxExtender>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="BasicItemForCalculatingTotalSurgeryAmt">
                    <ItemTemplate>
                        <asp:Label ID="lblTypeIDforTS" runat="server" Visible="false" Text='<%# Bind("Type_ID") %>'></asp:Label>
                        <asp:RadioButtonList ID="rbtnBase" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="1">YES</asp:ListItem>
                            <asp:ListItem Value="0">NO</asp:ListItem>
                        </asp:RadioButtonList>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="IsThisDoctor">
                    <ItemTemplate>
                        <asp:Label ID="lblTypeIDdoc" Visible="false" runat="server" Text='<%# Bind("Type_ID") %>'></asp:Label>
                        <asp:RadioButtonList ID="rbtnBindDoc" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="1">YES</asp:ListItem>
                            <asp:ListItem Value="0">NO</asp:ListItem>
                        </asp:RadioButtonList>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Description">
                    <ItemTemplate>
                        <asp:TextBox ID="txtSequenceNumber" runat="server" Text='<%# Bind("Description") %>'></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtSequenceNumber"
                            FilterType="Numbers">
                        </cc1:FilteredTextBoxExtender>
                        <asp:Label ID="lblItemID" runat="server" Text='<%# Bind("ItemID") %>' Visible="false"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CommandField SelectText="Edit" ShowSelectButton="True"></asp:CommandField>
            </Columns>
        </asp:GridView>

    </div>
</asp:Content>
