<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SurgeryMaster.aspx.cs" Inherits="Design_EDP_SurgeryMaster"
    MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Surgery Master
            </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>


        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-4">
                            <asp:RadioButton ID="rdbNew" runat="server" Text="ADD" Font-Bold="True" GroupName="SAME"
                                AutoPostBack="True" OnCheckedChanged="rdbNew_CheckedChanged" Checked="true"
                                ToolTip="Select Add To Add New Procedure Master"></asp:RadioButton>
                            <asp:RadioButton ID="rdbEdit" runat="server" Text="EDIT" Font-Bold="True" GroupName="SAME"
                                AutoPostBack="True"
                                OnCheckedChanged="rdbEdit_CheckedChanged"
                                ToolTip="Select Edit To Update Procedure Master"></asp:RadioButton>
                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

        </div>
        <br />
        <br />
        <asp:MultiView ID="MultiView1" runat="server">
            <asp:View ID="View1" runat="server">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Surgery Master 
                    </div>
                    <div style="text-align: center">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-22">
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            Surgery Name
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtSurgeryName" CssClass="requiredField" runat="server" MaxLength="100" Width="95%"
                                            AutoCompleteType="Disabled" ToolTip="Enter Surgery Name"></asp:TextBox>
                                    </div>

                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            Department
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:DropDownList ID="ddlDept" runat="server" ToolTip="Select Department">
                                        </asp:DropDownList>

                                    </div>
                                    <div class="col-md-1">
                                        <asp:Button ID="btnNew" runat="server" Text="New"
                                            ToolTip="Click To View" CssClass="ItDoseButton" />
                                    </div>
                                    <div class="col-md-2">
                                        <label class="pull-left">
                                            Item Code
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtItemCode" runat="server" MaxLength="10" Width="190px"
                                            AutoCompleteType="Disabled" ToolTip="Enter Item Code"></asp:TextBox>
                                    </div>
                                </div>
                                 <div class="row" style="display:none;">
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            Surgery Group
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-21">
                                       <asp:CheckBoxList ID="chkSurgeryGroup" runat="server" RepeatDirection="Horizontal" RepeatColumns="10"></asp:CheckBoxList>
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-md-10">
                                    </div>
                                    <div class="col-md-4">
                                        <asp:Button ID="btnSave" CssClass="ItDoseButton" OnClick="btnSave_Click" runat="server" Text="Save" ValidationGroup="save"></asp:Button>
                                        <asp:ValidationSummary ID="ValidationSummary1" ValidationGroup="save" runat="server"
                                            ShowMessageBox="True" ShowSummary="False" />
                                    </div>
                                    <div class="col-md-10">
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-1"></div>
                        </div>
                    </div>
                </div>
            </asp:View>
            <asp:View ID="View2" runat="server">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Edit Procedure Master:
                    </div>
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Surgery Name
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled"
                                        CssClass="labinputbox" Height="22px"
                                        ToolTip="Enter Surgery Name"></asp:TextBox>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Department
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlDept1" runat="server" ToolTip="Select department">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        CPT Code
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtItemCode1" runat="server" CssClass="labinputbox" Height="22px"
                                         AutoCompleteType="Disabled" ToolTip="Enter CPT Codes"></asp:TextBox>

                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-11">
                                </div>
                                <div class="col-md-2">
                                    <asp:Button ID="btnView" OnClick="btnView_Click" runat="server" Text="View"
                                        ToolTip="Click To View" CssClass="ItDoseButton" />
                                    <asp:Label ID="lblMsg1" runat="server" ForeColor="Maroon"></asp:Label>
                                </div>
                                <div class="col-md-11">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>


                    <table style="width: 100%; overflow:auto;">
                        <tr>
                            <td style="text-align: center;" colspan="5">
                                <asp:GridView ID="GridView1" runat="server" Width="100%" AutoGenerateColumns="False"
                                    OnRowUpdating="GridView1_RowUpdating" OnRowCancelingEdit="GridView1_RowCancelingEdit"
                                    OnRowEditing="GridView1_RowEditing" CssClass="GridViewAltItemStyle">
                                    <Columns>
                                          <asp:TemplateField HeaderText="Surgery Group">
                                            <ItemStyle Width="100px"></ItemStyle>
                                            <ItemTemplate>
                                                <asp:Label ID="lblSurgeryGroup" runat="server" Text='<%# Bind("GroupName") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Surgery Name">
                                            <EditItemTemplate>
                                                <asp:TextBox ID="txtSurgery" runat="server" Text='<%# Bind("Name") %>' Width="225px"></asp:TextBox>
                                            </EditItemTemplate>
                                            <ItemStyle Width="700px"></ItemStyle>
                                            <ItemTemplate>
                                                <asp:Label ID="lblSurgeryName" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Department">
                                            <EditItemTemplate>&nbsp;<asp:DropDownList ID="ddlDept" runat="server"></asp:DropDownList><asp:Label ID="lblDept1" runat="server" Text='<%# Bind("Department") %>' Visible="False"></asp:Label></EditItemTemplate>
                                            <ItemStyle Width="700px"></ItemStyle>
                                            <ItemTemplate>
                                                <asp:Label ID="lblDept" runat="server" Text='<%# Bind("Department") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Surgery Code">
                                            <EditItemTemplate>
                                                <asp:TextBox ID="txtSurgeryCode" runat="server" Text='<%# Bind("SurgeryCode") %>'
                                                    Width="198px"></asp:TextBox>
                                            </EditItemTemplate>
                                            <ItemStyle Width="700px"></ItemStyle>
                                            <ItemTemplate>
                                                <asp:Label ID="lblSurgeryCode" runat="server" Text='<%# Bind("SurgeryCode") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Is Active">
                                            <EditItemTemplate>
                                                &nbsp;<asp:DropDownList ID="ddlIsActive" runat="server" Width="58px" SelectedValue='<%# Bind("IsActive") %>'>
                                                    <asp:ListItem Selected="True" Value="False">False</asp:ListItem>
                                                    <asp:ListItem Value="True">True</asp:ListItem>
                                                </asp:DropDownList>
                                            </EditItemTemplate>
                                            <ItemStyle Width="40px"></ItemStyle>
                                            <ItemTemplate>
                                                <asp:Label ID="lblActive" runat="server" Text='<%# Bind("IsActive") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSurgery_ID" runat="server" Text='<%# Eval("Surgery_ID") %>'></asp:Label>
                                                 <asp:Label ID="lblGroupID" runat="server" Text='<%# Eval("GroupID") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:CommandField ShowEditButton="True" HeaderStyle-CssClass="GridViewHeaderStyle">
                                            <ItemStyle Width="100px"></ItemStyle>
                                        </asp:CommandField>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>

                    </table>
                </div>
            </asp:View>
        </asp:MultiView>
        <asp:Panel ID="PnlDepartmentNew" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none"
            Width="360px">
            <div class="Purchaseheader" runat="server">
                <strong>Create Department</strong>
            </div>
            <div>
                <table>
                    <tr>
                        <td>Department :
                        </td>
                        <td>
                            <asp:TextBox ID="txtDepartment" runat="server" Width="140px" MaxLength="100"
                                ClientIDMode="Static">
                            </asp:TextBox>
                            <asp:Label ID="Label8" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>

                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;
                        </td>
                        <td>
                            <asp:Button ID="btnDepartment" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnDepartment_Click"
                                CausesValidation="false" />
                            <asp:Button ID="btnDepartmentCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                                CausesValidation="false" />
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" CancelControlID="btnDepartmentCancel"
            DropShadow="true" TargetControlID="btnNew" BackgroundCssClass="filterPupupBackground"
            PopupControlID="PnlDepartmentNew" PopupDragHandleControlID="Div1">
        </cc1:ModalPopupExtender>
    </div>
</asp:Content>
