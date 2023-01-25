<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="RelievingLetterSearch.aspx.cs" Inherits="Design_RelievingLetterSearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <script type="text/javascript">
        function doClick(buttonName, e) {
            //the purpose of this function is to allow the enter key to
            //point to the correct button to click.
            var key;

            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox

            if (key == 13) {
                //Get the button the user wants to have clicked
                var btn = document.getElementById(buttonName);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                }
            }
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {

            $('#txtIssuedatefrom').change(function () {
                ChkDate();

            });

            $('#txtIssueDateTo').change(function () {
                ChkDate();

            });

        });

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtIssuedatefrom').val() + '",DateTo:"' + $('#txtIssueDateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblmsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblmsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');

                    }
                }
            });

        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align:center">
            <b>Relieving Letter Search </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Employee ID 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtEmployeeid" runat="server" MaxLength="20" TabIndex="1"
                                ToolTip="Enter Employee ID"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Employee Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtName" runat="server" MaxLength="50" TabIndex="2"
                                ToolTip="Enter Employee Name"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkDate" runat="server" />Relieving From 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtIssuedatefrom" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calucIssueDateFrom" runat="server" TargetControlID="txtIssuedatefrom"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Relieving To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtIssueDateTo" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calIssueDateTo" runat="server" TargetControlID="txtIssueDateTo"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-22" align="center">
                            <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
                                ValidationGroup="v1" CssClass="ItDoseButton" TabIndex="5" ToolTip="Click to Search" Style="margin-top: 7px; width: 100px;" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-24" align="center">
                    <asp:GridView ID="grirecord" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                                OnRowCommand="grirecord_RowCommand">
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Employee ID" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblid" runat="server" Text='<%#Eval("EmployeeID")%>' Visible="false"></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="EmployeeID">
                                        <ItemTemplate>
                                            <%#Eval("EmployeeID")%>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Employee Name">
                                        <ItemTemplate>
                                            <%#Eval("Name")%>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" Width="240px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Document No.">
                                        <ItemTemplate>
                                            <%#Eval("documentno")%>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Issue Date">
                                        <ItemTemplate>
                                            <%#Eval("IssueDate")%>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="D.O.L.">
                                        <ItemTemplate>
                                            <%#Eval("Dateofleaving")%>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Edit">
                                        <ItemTemplate>
                                            <%--  <% if (ViewState["Permission"].ToString() == "Edit" || ViewState["Permission"].ToString() == "All")
                                                    {%>--%>
                                            <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandArgument='<%# Eval("EmployeeID") %>'
                                                CommandName="AEdit" ImageUrl="~/Images/edit.png" />
                                            <%--  <%} %>--%>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Print">
                                        <ItemTemplate>
                                            <%--     <% if (ViewState["Permission"].ToString() == "Cancel" || ViewState["Permission"].ToString() == "All")
                                                    {%>--%>
                                            <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandArgument='<%# Eval("EmployeeID")%>'
                                                CommandName="RPrint" ImageUrl="~/Images/Print.gif" />
                                            <%-- <%} %>--%>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                </div>

            </div>
            </div>
        </div>
</asp:Content>
