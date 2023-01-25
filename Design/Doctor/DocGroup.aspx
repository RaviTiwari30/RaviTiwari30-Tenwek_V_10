<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="DocGroup.aspx.cs" Inherits="Design_Doctor_DocGroup" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        function RestrictDoubleEntry(btn) {
            if ($("#<%=txtDocType.ClientID %>").val() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Enter Doctor Type');
                $("#<%=txtDocType.ClientID %>").focus();
                return false;
            }

            else
                $("#<%=lblMsg.ClientID %>").text('');
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }

        var _oldColor;
        function SetNewColor(source) {
            _oldColor = source.style.backgroundColor;
            source.style.backgroundColor = '#00FFFF';
        }

        function SetOldColor(source) {
            source.style.backgroundColor = _oldColor;
        }
        function ShowPO(PONo) {
            window.open(PONo);
        }
    </script>

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Doctor Group Master </b>
            <br />
            <asp:Label ID="lblMsg" Text="" CssClass="ItDoseLblError" runat="server"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-4">
                            <asp:RadioButtonList ID="rbtnStatus" runat="server" AutoPostBack="True" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged"
                                RepeatDirection="Horizontal"
                                ToolTip="Select New Or Edit To Update Doc Type">
                                <asp:ListItem Selected="True">NEW</asp:ListItem>
                                <asp:ListItem>EDIT</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>


        </div>
        <asp:MultiView ID="MultiView1" runat="server">
            <asp:View ID="View1" runat="server">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Create Doctor Group
                    </div>
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Doctor Type 
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtDocType" Width="95%" runat="server" TabIndex="1"
                                        ToolTip="Enter Doctor Type" MaxLength="20"></asp:TextBox>
                                    <span style="color: red; font-size: 10px;">*</span>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Active
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:RadioButtonList ID="rbtnActive" runat="server" TabIndex="2"
                                        RepeatDirection="Horizontal" ToolTip="Select Yes Or No To Active Doctor Type">
                                        <asp:ListItem Selected="True" Value="1">YES</asp:ListItem>
                                        <asp:ListItem Value="0">NO</asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <asp:Button ID="btnSave" Text="Save" CssClass="ItDoseButton" runat="server"
                        OnClientClick="return RestrictDoubleEntry(this);" OnClick="btnSave_Click"
                        TabIndex="3" ToolTip="Click To Save" />
                </div>
            </asp:View>
            <asp:View ID="View2" runat="server">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Edit Doctor Group
                    </div>
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-7">
                                </div>
                                <div class="col-md-12">
                                    <Ajax:UpdatePanel ID="UpdatePanel1" runat="server">
                                        <ContentTemplate>
                                            <asp:GridView ID="grdLabSearch" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                                OnRowDataBound="grdLabSearch_RowDataBound" Width="380px" OnSelectedIndexChanged="grdLabSearch_SelectedIndexChanged">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="S.No.">
                                                        <ItemTemplate>
                                                            <%#Container.DataItemIndex+1 %>
                                                            <asp:Label ID="lblID" runat="server" Text='<%#Eval("ID") %>' Width="200px" Visible="false"></asp:Label>
                                                        </ItemTemplate>
                                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Doctor Type">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtDoctype" MaxLength="20" runat="server" Text='<%#Eval("Doctype") %>'></asp:TextBox>
                                                            <span style="color: red; font-size: 10px;">*</span>
                                                        </ItemTemplate>
                                                        <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Left" />
                                                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Active">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblActive" Visible="false" runat="server" Text='<%#Eval("IsActive") %>'></asp:Label>
                                                            <asp:RadioButtonList ID="rbtnActive2" runat="server" RepeatDirection="Horizontal">
                                                                <asp:ListItem>YES</asp:ListItem>
                                                                <asp:ListItem>NO</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </ItemTemplate>
                                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:CommandField ShowSelectButton="True" SelectText="Update" HeaderText="Update">
                                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                                        <%--<ItemStyle CssClass="GridViewLabItemStyle" />--%>
                                                    </asp:CommandField>
                                                </Columns>
                                            </asp:GridView>
                                        </ContentTemplate>
                                    </Ajax:UpdatePanel>
                                    <Ajax:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                                        <ProgressTemplate>
                                            <asp:Image ID="Image1" runat="server" Width="38px" Height="31px" ImageUrl="~/Images/25-1.gif"></asp:Image><br />
                                        </ProgressTemplate>
                                    </Ajax:UpdateProgress>
                                </div>
                                <div class="col-md-5">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
            </asp:View>
        </asp:MultiView><br />
    </div>
</asp:Content>
