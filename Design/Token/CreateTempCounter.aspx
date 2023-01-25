<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CreateTempCounter.aspx.cs" Inherits="Design_Token_CreateTempCounter" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style type="text/css">
        #ctl00_ContentPlaceHolder1_txtCounter {
            width:20%;
        }
        .edit {
            text-decoration:none;
            background-color:#018EFF;
            color:white;
            padding:2px 5px 2px 5px;
            border-radius:4px;
            font-size:11px;
            margin-bottom:0px;
        }
        .txtedit {
            border:1px solid #000000;
        }
    </style>

    <script type="text/javascript">
        function ValidateCenter() {
            if ($('#<%=txtCounter.ClientID%>').val() == "") {
                modelAlert("Please enter Counter");
                return false;
            }

            var data;
            if ($('#<%=txtCounter.ClientID%>').val() != "") {
                var counter = $('#<%=txtCounter.ClientID%>').val();

                $.ajax({
                    url: 'CreateTempCounter.aspx/CheckCenterExists',
                    data: '{Countername:"' + counter + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    type: "POST",
                }).done(function (r) {
                    data = JSON.parse(r.d);
                    
                    
                    
                });
            }

            if (data == "YES") {
                modelAlert("Counter already exists try another name");
                return false;
            }

        }

        function SuccessMsg() {
            alert("Deleted Successfull");
        }
    </script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="content col-md-24" style="text-align: center;">
                <b>Create Counter</b>
                <br />
                <span style="font-size: 12pt">
                    <asp:Label ID="lblmsg" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="Red"></asp:Label></span>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <center><asp:TextBox ID="txtCounter" runat="server" placeholder="Enter Counter"></asp:TextBox></center>
                </div>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <center><asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" OnClientClick="return ValidateCenter()" Text="Save" /></center>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Counter List
            </div>
            <br />
            <asp:UpdatePanel runat="server" ID="up2">
                <ContentTemplate>
            <asp:GridView ID="dgGrid" runat="server" AutoGenerateColumns="false" Width="100%" OnRowDeleting="dgGrid_RowDeleting" 
                OnRowEditing="dgGrid_RowEditing" OnRowUpdating="dgGrid_RowUpdating" OnRowCancelingEdit="dgGrid_RowCancelingEdit" DataKeyNames="Id">
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Counter Name">
                        <ItemTemplate>
                            <%#Eval("CounterName") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditCounter" runat="server" CssClass="txtedit" Text='<%#Eval("CounterName") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                    </asp:TemplateField>
                    <%--<asp:TemplateField HeaderText="Edit">
                        <ItemTemplate>
                            <asp:Label Text="Edit" runat="server" ID="lblEdit"></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>--%>
                    <%--<asp:TemplateField HeaderText="Delete">
                        <ItemTemplate>
                            <asp:Button Text="Delete" runat="server" ID="lblDelete" CausesValidation="false" CommandName="Delete" CommandArgument='<%#Eval("Id") %>'></asp:Button>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>--%>
                    <asp:CommandField ButtonType="Link" ShowEditButton="true" ItemStyle-Width="150" HeaderStyle-BackColor="#2C5A8B" HeaderText="Edit" HeaderStyle-ForeColor="White" ControlStyle-CssClass="edit" />
                    <asp:CommandField ButtonType="Link" ShowDeleteButton="true" ItemStyle-Width="150" HeaderStyle-BackColor="#2C5A8B" HeaderText="Delete" HeaderStyle-ForeColor="White" ControlStyle-CssClass="edit" />
                </Columns>
            </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>

