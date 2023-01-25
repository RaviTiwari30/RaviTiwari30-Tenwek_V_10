<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="PaymentConformation.aspx.cs" Inherits="Design_Store_PaymentConformation" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" >
        $(document).ready(function () {
            $('#txtfromDate').change(function () {
                ChkDate();
            });

            $('#txtToDate').change(function () {
                ChkDate();
            });

        });

        

        function ChkDate() {

            $.ajax({

                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtfromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');
                        $("#tbAppointment table").remove();
                        $("#<%= grdItem.ClientID%>").hide();

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div>
                <div style="text-align: center;">
                    <b>Pharmacy Payment Confirmation </b>
                </div>
                <div style="text-align: center;">
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria</div>
            <div>
                <table cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td style="width: 22%; text-align: right;">
                            &nbsp;&nbsp; From Date :&nbsp;
                        </td>
                        <td style="width: 30%">
                            <asp:TextBox ID="txtfromDate" runat="server" 
                                ToolTip="Click To Select From Date" Width="145px" TabIndex="1" 
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtfromDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 15%; text-align: right;">
                            To Date :&nbsp;
                        </td>
                        <td style="width: 18%">
                            <asp:TextBox ID="txtToDate" runat="server"  ToolTip="Click To Select To Date"
                                Width="145px" TabIndex="2"  ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtCurrentDate0_CalendarExtender" runat="server" TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 15%;">
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 22%; text-align: right;">
                            UHID :&nbsp;
                        </td>
                        <td style="width: 15%; text-align: left; margin-left: 40px;">
                            <asp:TextBox ID="txtMRNo" MaxLength="20" ToolTip="Enter UHID" runat="server" Width="145px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 15%;">
                            Status :&nbsp;
                        </td>
                        <td style="width: 15%; text-align: left;">
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="ItDoseLabel" Width="149px">
                                <asp:ListItem Text="Confirmed" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Pending" Value="1"></asp:ListItem>
                                <asp:ListItem Text="All" Selected="True" Value="2"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td style="width: 15%;">
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center;" colspan="5">
                            <asp:Button ID="btnSearch" runat="server" Text="Search" ClientIDMode="Static" TabIndex="4"
                                ToolTip="Click To Search" CssClass="ItDoseButton" OnClick="btnSearch_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="5" style="text-align: left">
                            <table style="width: 100%">
                                <tr align="center">
                                    <td style="width: 35%; text-align: right;">
                                        Confirmed
                                    </td>
                                    <td style="background-color: LightBlue; width: 5%; height: 8px;">
                                    </td>
                                    <td style="width: 10%; height: 8px;">
                                    </td>
                                    <td style="width: 10%; text-align: right; height: 8px;">
                                        Pending
                                    </td>
                                    <td style="background-color: LightPink; width: 5%; height: 8px;">
                                    </td>
                                    <td style="width: 35%;">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Results</div>
            <table width="100%">
                <tr align="center">
                    <td>
                        <asp:GridView ID="grdItem" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            Style="width: 100%;" OnRowCommand="grdItem_RowCommand" OnRowDataBound="grdItem_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UHID">
                                    <ItemTemplate>
                                        <%#Eval("PatientID")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Patient Name">
                                    <ItemTemplate>
                                        <%#Eval("Pname")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Address">
                                    <ItemTemplate>
                                        <%#Eval("Address") %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Date">
                                    <ItemTemplate>
                                        <%#Eval("DATE")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Amount">
                                    <ItemTemplate>
                                        <%#Eval("Adjustment")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Print">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                            ImageUrl="~/Images/print.gif" CommandArgument='<%# Eval("LedgerTransactionNo")+"$"+Eval("TypeOfTnx")%>' />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Confirm">
                                    <ItemTemplate>
                                        <asp:Button ID="btnConfirm" runat="server" CssClass="ItDoseButton" Text="Confirm"
                                            CommandName="Conform" CommandArgument='<%# Eval("LedgerTransactionNo")%>' />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField Visible="false">
                                    <ItemTemplate>
                                    <asp:Label ID="lblIsCancel" runat="server" Text='<%# Eval("IsCancel") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
