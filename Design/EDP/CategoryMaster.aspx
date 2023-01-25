<%@ Page Language="C#" MaintainScrollPositionOnPostback="true" MasterPageFile="~/DefaultHome.master"
    AutoEventWireup="true" CodeFile="CategoryMaster.aspx.cs" Inherits="Design_EDP_CategoryMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">

        var _oldColor;
        function SetNewColor(source) {
            _oldColor = source.style.backgroundColor;
            source.style.backgroundColor = '#387C44';
        }

        function SetOldColor(source) {
            source.style.backgroundColor = _oldColor;
        }
        function ShowPO(PONo) {
            window.open(PONo);
        }

        function RestrictDoubleEntry() {
            if ($.trim($("#<%=txtName.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Name');
                $("#<%=txtName.ClientID%>").focus();
                return false;
            }
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');

        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <ajax:ScriptManager ID="ScriptManager1" runat="server">
            </ajax:ScriptManager>
            <b>Category Master</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-4">
                            <asp:RadioButtonList ID="rbtnStatus" runat="server" AutoPostBack="True" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged"
                                RepeatDirection="Horizontal"
                                ToolTip="Select New Or Edit To Update Category">
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
        <br />
        <br />
        <asp:MultiView ID="MultiView1" runat="server">
            <asp:View ID="View1" runat="server">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Category Master
                    </div>
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Category Type
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                        <ContentTemplate>
                                            <asp:DropDownList ID="ddlCategoryType" AutoPostBack="true" runat="server"
                                                OnSelectedIndexChanged="ddlCategoryType_SelectedIndexChanged"
                                                ToolTip="Select Category Type">
                                                <asp:ListItem>ID</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:Label ID="lblRemarks" runat="server" ForeColor="#C04000"></asp:Label>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Name
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtName" runat="server" Width="95%"
                                        ToolTip="Enter Category Name" MaxLength="50"></asp:TextBox>
                                    <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Abbreviation
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtAbbreviation" runat="server" MaxLength="4"
                                        ToolTip="Enter Category Abbreviation"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Active
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:RadioButtonList ID="rbtnActive" runat="server"
                                        RepeatDirection="Horizontal"
                                        ToolTip="Select Yes Or No To Update Category">
                                        <asp:ListItem Selected="True" Value="1">YES</asp:ListItem>
                                        <asp:ListItem Value="0">NO</asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Print Order No.
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtOrdeno" runat="server" ToolTip="Enter Print Order No."></asp:TextBox>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                    </label>
                                </div>
                                <div class="col-md-5">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center">

                    <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save"
                        OnClientClick="return RestrictDoubleEntry();" CssClass="ItDoseButton"
                        ToolTip="Click To Save" />

                </div>
            </asp:View>
            <asp:View ID="View2" runat="server">
                <div class="POuter_Box_Inventory" style="width:100%">
                    <div class="Purchaseheader">
                        Edit Category Master
                    </div>
                    <div  style="text-align: center">
                        <table style="width: 100%">
                            <tr>
                                <td style="width: 16%; text-align: right"></td>
                                <td style="width: 11%; text-align: right">Category Type :
                                </td>
                                <td style="width: 23%; text-align: left;">
                                    <asp:DropDownList ID="ddlCategoryType1" runat="server" Width="226px"
                                        ToolTip="Select Category type">
                                        <asp:ListItem>ID</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 25%; text-align: left;">
                                    <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
                                        CssClass="ItDoseButton" ToolTip="Click To Search" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 16%; height: 17px"></td>
                                <td style="width: 11%; height: 17px"></td>
                                <td style="width: 23%; height: 17px"></td>
                                <td style="width: 25%; height: 17px"></td>
                            </tr>
                            <tr>
                                <td colspan="4" style="text-align: center">
                                    <asp:GridView ID="grdSearch" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                        OnRowDataBound="grdSearch_RowDataBound" OnSelectedIndexChanged="grdSearch_SelectedIndexChanged1"
                                        Width="100%">
                                        <Columns>
                                            <asp:TemplateField HeaderText="ID">
                                                <ItemTemplate>
                                                    <%#Container.DataItemIndex+1 %>
                                                    <asp:Label ID="lblConfigRelID" runat="server" Text='<%# Bind("ConfigID") %>'
                                                        Visible="false"></asp:Label>
                                                    <asp:Label ID="lblCategoryID" runat="server" Text='<%# Bind("CategoryID") %>' Visible="false"></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Name">
                                                <ItemTemplate>
                                                    <asp:TextBox ID="txtName" runat="server" Text='<%# Bind("Name") %>' Width="300px"></asp:TextBox>
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="IsActive">
                                                <EditItemTemplate>
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="lblActive" runat="server" Text='<%# Bind("Active") %>' Visible="false"></asp:Label>
                                                    <asp:RadioButtonList ID="rbtnActive2" runat="server" RepeatDirection="Horizontal">
                                                        <asp:ListItem>YES</asp:ListItem>
                                                        <asp:ListItem>NO</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                            </asp:TemplateField>
                                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/Images/edit.png" HeaderText="Edit" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                        </Columns>
                                    </asp:GridView>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </asp:View>
        </asp:MultiView>
    </div>
</asp:Content>
