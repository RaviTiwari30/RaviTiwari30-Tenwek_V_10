<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleContainerMaster.aspx.cs" Inherits="Design_Investigation_SampleContainerMaster" %>

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
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
  <%--  <Ajax:UpdateProgress ID="updateProgress" runat="server">
        <ProgressTemplate>
            <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
                <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading
                    <img src="../Purchase/Image/progress_bar.gif" /></span>
            </div>
        </ProgressTemplate>
    </Ajax:UpdateProgress>--%>
    <Ajax:UpdatePanel ID="up" runat="server">
        <ContentTemplate>
            <div id="Pbody_box_inventory">
                <div class="POuter_Box_Inventory" style="text-align: center;">

                    <b>&nbsp;Sample Container Master</b>&nbsp;<br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

                </div>

                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Add Details&nbsp;
                    </div>
                    <div class="col-md-24">
                        <div class="col-md-3">
                            <label class="pull-left">Container Name</label>    
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"><asp:TextBox ID="txtdeptname" runat="server" Width="223px" Style="text-transform: uppercase;" CssClass="required"></asp:TextBox>
                            <asp:TextBox ID="txtId" Visible="false" runat="server" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Container Color</label>    
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">  <asp:DropDownList ID="ddlcolor" runat="server">
                                </asp:DropDownList></div>
                        <div class="col-md-3">
                            <label class="pull-left">Sample Quantity</label>    
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">   <asp:TextBox ID="txtqty" runat="server"  Width="50px" CssClass="required"></asp:TextBox><b>(Unit in ml.)</b>
                                </div>
                    </div>
                </div>
                <div  class="POuter_Box_Inventory" style="text-align: center;">
                            <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" CssClass="itdosebtnnew" ValidationGroup="save" />
                                <asp:Button ID="btnUpdate" runat="server" OnClick="Unnamed_Click" Text="Update" CssClass="itdosebtnnew" ValidationGroup="save" />
                </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Container List&nbsp;
            </div>
            
                 <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td align="center"><strong>Search By Name :&nbsp;</strong><asp:TextBox ID="txtsearch" runat="server" Width="260px"></asp:TextBox>
                            &nbsp;&nbsp;
                  <asp:Button ID="btnsearch" Text="Search" runat="server" OnClick="btnsearch_Click" CssClass="itdosebtnnew" />
                        </td>
                    </tr>
                    <tr>
                        <td align="center">

                            <div style="overflow: scroll; height: 300px; ">
                                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" Width="99%" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" EnableModelValidation="True">
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No.">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Name">


                                            <ItemTemplate>
                                                <asp:Label ID="Label2" runat="server" Text='<%# Bind("name") %>'></asp:Label>
                                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("id") %>' Visible="false"></asp:Label>
                                                <asp:Label ID="Label3" runat="server" Text='<%# Bind("color") %>' Visible="false"></asp:Label>
                                                <asp:Label ID="label4" runat="server" Text='<%# Bind("qty") %>' Visible="false"></asp:Label>

                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:BoundField DataField="color" HeaderText="Color" />
                                        <asp:BoundField DataField="myqt" HeaderText="Quantity" />

                                        <asp:TemplateField HeaderText="Edit">

                                            <ItemTemplate>
                                                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                                                    Text="Select"></asp:LinkButton>
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


