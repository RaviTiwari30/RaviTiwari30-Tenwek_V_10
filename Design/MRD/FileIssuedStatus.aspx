<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FileIssuedStatus.aspx.cs" Inherits="Design_MRD_FileIssuedStatus" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();
            });
            $('#ucToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=grdMRD.ClientID %>').hide();
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                        $('#<%=grdMRD.ClientID %>').val(null);
                    }
                }
            });
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>MRD&nbsp;Issued File Status</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <table style="text-align: center; width: 100%;display:none">
                <tr style="text-align: center">
                    <td align="center">
                        <asp:RadioButtonList ID="rdbselectedtype" runat="server" RepeatColumns="4"
                            RepeatDirection="Horizontal" Width="225px">
                            <asp:ListItem Text="All" Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="IPD" Value="2"></asp:ListItem>
                            <asp:ListItem Text="OPD" Value="3"></asp:ListItem>
                            <asp:ListItem Text="General" Value="4"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                         <div class="col-md-3">
                             <label class="pull-left">
                                 Patient Type
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="ddlPatientType" runat="server" ClientIDMode="Static"></asp:DropDownList>
                         </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMrno" runat="server" MaxLength="25" Width=""></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtpname" runat="server" MaxLength="50" Width=""></asp:TextBox>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Issued Date from
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date" Width=""
                                TabIndex="1"></asp:TextBox>
                            <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Issued Date To 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date" Width=""
                                TabIndex="2"></asp:TextBox>
                            <cc1:CalendarExtender ID="ToDatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="3" Text="Search"
                    OnClick="btnSearch_Click" ToolTip="Click to Search" />
                <br />

            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                Result
            </div>
            <table id="tbAppointment">
                <tr align="center">
                    <td>
                        <asp:GridView ID="grdMRD" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>

                                  <asp:TemplateField HeaderText="Patient Type">
                                    <ItemTemplate>
                                        <asp:Label ID="lblfileid" runat="server" Text='<%#Eval("ptype") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="File ID">
                                    <ItemTemplate>
                                        <asp:Label ID="lblfileid" runat="server" Text='<%#Eval("fileid") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UHID ">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPatientID" runat="server" Text='<%#Eval("PatientID") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Patient Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPatientName" runat="server" Text='<%#Eval("pname") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Issue To">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIssue_To" runat="server" Text='<%#Eval("issuename") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Issue To Department">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDepartment" runat="server" Text='<%#Eval("Department") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Issue Date" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblIssueDate" runat="server" Text='<%#Eval("IssueDate") %>'></asp:Label>

                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Issue" Visible="false" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblissuedfrom" runat="server" Text='<%#Eval("issuedfrom") %>'></asp:Label>

                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
