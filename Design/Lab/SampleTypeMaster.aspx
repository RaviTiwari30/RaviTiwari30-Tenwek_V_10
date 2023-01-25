<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleTypeMaster.aspx.cs" Inherits="Design_Investigation_SampleTypeMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <script type="text/javascript">
        function ConfirmOnDelete(item, type) {
            var msg = "";
            if (type == "1") {
                msg = "Are you sure to deactive : " + item + "?";
            }
            else {
                msg = "Are you sure to active : " + item + "?";
            }
            if (confirm(msg) == true)
                return true;
            else
                return false;
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
    <Ajax:UpdatePanel ID="up" runat="server">
        <ContentTemplate>
            <div id="Pbody_box_inventory">
                <div class="POuter_Box_Inventory" style="text-align: center;">

                    <b>&nbsp;Sample Type Master</b>&nbsp;<br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

                </div>

                <div class="POuter_Box_Inventory">
                    <div class="col-md-25">
                    <div class="row">
                        <div class="Purchaseheader">
                            Add Details&nbsp;
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3"   runat="server">
                            <label class="pull-left">
                                <b>Sample Name</b>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtdeptname" runat="server" Width="200px" Style="text-transform: uppercase;" CssClass="requiredField" AutoCompleteType="Disabled"></asp:TextBox>
                             <asp:TextBox ID="txtId" Visible="false" runat="server" />
                        </div>
                         <div id="Div2"  class="col-md-3" runat="server">
                            <label class="pull-left">
                                <b>Container Name</b>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <%--<asp:TextBox ID="txtContainerName" CssClass="requiredField" runat="server" Width="200px" AutoCompleteType="Disabled" Style="text-transform: uppercase;"></asp:TextBox>--%> 
                            <asp:DropDownList ID="ddlcontainername" runat="server" style="width:200px;" CssClass="requiredField" AutoPostBack="true" OnSelectedIndexChanged="ddlcontainername_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                          <div id="Div1"    class="col-md-3" runat="server">
                            <label class="pull-left">
                                <b>Container Color</b>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlContainerColor" runat="server" Width="200px"></asp:DropDownList>
                        </div> 
                    </div>
                    <div class="row">
                               <div id="Div3" class="col-md-3" runat="server">
                            <label class="pull-left">
                                <b> Display Name</b>  <%--Lab Report--%>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtdisplayname" runat="server" Width="200px" CssClass="requiredField" Style="text-transform: uppercase;" AutoCompleteType="Disabled"></asp:TextBox> 
                        </div>
                    <div class="col-md-7">
                         <label class="pull-right">
                             <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" CssClass="itdosebtnnew" ValidationGroup="save" />
                             <asp:Button ID="btnUpdate" runat="server" OnClick="Unnamed_Click" Text="Update" CssClass="itdosebtnnew" ValidationGroup="save" />
                         </label>
                        </div>

                         <div     class="col-md-7" runat="server">
                            <label class="pull-right">
                                <b> 
                           <asp:CheckBox ID="chkActive" runat="server" Checked="true" Text="Active" TextAlign="right" /> 
                                </b>
                            </label>
                            <b class="pull-right"> </b>
                        </div>
                        
                    </div> 
                    </div> 
                    <%--<table style="width: 100%;">
                        <tr>
                            <td style="text-align: right; width: 525px;"><b>Sample Name :</b></td>
                            <td>
                                <asp:TextBox ID="txtdeptname" runat="server" Width="223px" Style="text-transform: uppercase;" AutoCompleteType="Disabled"></asp:TextBox>

                                <asp:RequiredFieldValidator ID="r1" runat="server" ControlToValidate="txtdeptname" ErrorMessage="*" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                                <asp:TextBox ID="txtId" Visible="false" runat="server" /></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 441px;"><b>Lab Report Display Name :</b></td>
                            <td>
                                <asp:TextBox ID="txtdisplayname" runat="server" Width="223px" Style="text-transform: uppercase;" AutoCompleteType="Disabled"></asp:TextBox>

                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtdisplayname" ErrorMessage="*" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>
                            </td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 441px;"><b>Container Name :</b></td>
                            <td>
                                <asp:TextBox ID="txtContainerName" runat="server" Width="223px" AutoCompleteType="Disabled" Style="text-transform: uppercase;"></asp:TextBox>

                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtContainerName" ErrorMessage="*" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>
                            </td>
                            <td>&nbsp;</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 441px;"><b>Container Color :</b></td>
                            <td>
                                <asp:DropDownList ID="ddlContainerColor" runat="server" Width="227px"></asp:DropDownList>
                            </td>
                            <td>&nbsp;</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 441px;"><b></b></td>
                            <td>
                                <asp:CheckBox ID="chkActive" runat="server" Checked="true" Text="Active" TextAlign="right" />
                            </td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="6" style="text-align: center">
                                <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" CssClass="itdosebtnnew" ValidationGroup="save" />
                                <asp:Button ID="btnUpdate" runat="server" OnClick="Unnamed_Click" Text="Update" CssClass="itdosebtnnew" ValidationGroup="save" />
                            </td>
                        </tr>
                    </table>--%>
                </div> 

                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Sample List&nbsp;
                    </div>

                    <table style="width: 100%; border-collapse: collapse">
                        <tr>
                            <td align="center"><strong>Search By Name :</strong><asp:TextBox ID="txtsearch" runat="server" Width="260px"></asp:TextBox>
                                &nbsp;&nbsp;
                                <asp:Button ID="btnsearch" Text="Search" runat="server" OnClick="btnsearch_Click" CssClass="itdosebtnnew" />
                            </td>
                        </tr>
                        <tr>
                            <td align="center">

                                <div style="overflow: scroll; height: 300px;">
                                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnRowDeleting="GridView1_RowDeleting" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" OnRowDataBound="GridView1_RowDataBound" Width="99%" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" EnableModelValidation="True">
                                        <Columns>
                                            <asp:TemplateField HeaderText="S.No.">
                                                <ItemTemplate>
                                                    <%# Container.DataItemIndex + 1 %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Name">

                                                <EditItemTemplate>
                                                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("name") %>'></asp:TextBox>
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("name") %>'></asp:Label>
                                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("id") %>' Visible="false"></asp:Label>
                                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("isactive") %>' Visible="false"></asp:Label>

                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Display Name">

                                                <EditItemTemplate>
                                                    <asp:TextBox ID="txtdiplayname" runat="server" Text='<%# Bind("DisplayName") %>'></asp:TextBox>
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="lbldisplayname" runat="server" Text='<%# Bind("DisplayName") %>'></asp:Label>


                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Container">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblContainer" runat="server" Text='<%# Bind("Container") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Color Name">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblColorName" runat="server" Text='<%# Bind("ColorName") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Color Code">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblColor" runat="server" Text='<%# Bind("Color") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="status" HeaderText="Status" />
                                            <asp:TemplateField HeaderText="Edit">

                                                <ItemTemplate>
                                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                                                        Text="Select"></asp:LinkButton>
                                                </ItemTemplate>

                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="ChangeStatus">

                                                <ItemTemplate>
                                                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Delete"
                                                        Text="Deactive"></asp:LinkButton>
                                                </ItemTemplate>

                                            </asp:TemplateField>
                                        </Columns>
                                        <FooterStyle BackColor="White" ForeColor="#000066" />
                                        <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                                        <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                                        <RowStyle ForeColor="#000066" />
                                        <SelectedRowStyle BackColor="Pink" Font-Bold="True" />
                                    </asp:GridView>
                                </div>
                            </td>
                        </tr>

                    </table>

                </div>
            </div>

        </ContentTemplate>
    </Ajax:UpdatePanel>


</asp:Content>

