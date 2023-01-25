<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="AppraisalSearch.aspx.cs" Inherits="Design_Payroll_AppraisalSearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <script type="text/javascript" >
        $(function () {
            $('#txtFromDate').change(function () {
                ChkDate();

            });

            $('#txtToDate').change(function () {
                ChkDate();

            });

        });

       

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblmsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=EmpGrid.ClientID %>').hide();

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
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Appraisal Search </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td style="width: 21%; height: 6px;" align="right">
                        <asp:CheckBox ID="chkDate" runat="server" AutoPostBack="false" />
                        &nbsp;From Appraisal Date:
                    </td>
                    <td style="width: 18%; height: 6px;">

                        <asp:TextBox ID="txtFromDate" ClientIDMode="Static" runat="server" TabIndex="1" ToolTip="Select From Appraisal Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtFromDate"
                            Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%; height: 6px;" align="right">To Appraisal Date :
                    </td>
                    <td style="width: 20%; height: 6px;">

                        <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" TabIndex="2" ToolTip="Select To Appraisal Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="calucToDate" runat="server" TargetControlID="txtToDate"
                            Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 25%; height: 6px;">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 21%; height: 18px;" align="right">Appraisal Start Date :&nbsp;
                    </td>
                    <td style="width: 18%; height: 18px;">
                        <asp:DropDownList ID="ddlAppraisal" runat="server" TabIndex="3" ToolTip="Select Appraisal Start Date">
                        </asp:DropDownList>
                    </td>
                    <td align="right" valign="top" style="width: 20%; height: 18px;"></td>
                    <td style="width: 20%; height: 18px;" valign="top"></td>
                    <td style="width: 25%; height: 18px;"></td>
                </tr>
                <tr>
                    <td style="width: 21%"></td>
                    <td style="width: 18%"></td>
                    <td align="center" style="width: 20%">
                        <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
                            ValidationGroup="v1" TabIndex="4" ToolTip="Click to Search" CssClass="ItDoseButton" />&nbsp;&nbsp; &nbsp;&nbsp;
                    </td>
                    <td style="width: 20%"></td>
                    <td style="width: 25%"></td>
                </tr>
                <tr>
                    <td align="center" colspan="5">&nbsp; &nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="5">
                        <asp:GridView ID="EmpGrid" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                            OnRowCommand="EmpGrid_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Employee&nbsp;ID" Visible="true">
                                    <ItemTemplate>
                                        <%#Eval("employeeID")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Employee&nbsp;Name">
                                    <ItemTemplate>
                                        <%#Eval("Name")%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Designation">
                                    <ItemTemplate>
                                        <%#Eval("Desi_Name")%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Department">
                                    <ItemTemplate>
                                        <%#Eval("Dept_Name")%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Appraisal&nbsp;Date">
                                    <ItemTemplate>
                                        <%#Eval("Date")%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Type">
                                    <ItemTemplate>
                                        <%#Eval("AppraisalType")%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Print">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandArgument='<%# Eval("AppraisalNo")%>'
                                            CommandName="RPrint" ImageUrl="~/Images/Print.gif" ToolTip="Click to Print" />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>