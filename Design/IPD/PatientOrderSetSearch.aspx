<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="PatientOrderSetSearch.aspx.cs" Inherits="Design_IPD_PatientOrderSetSearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            $('#ucFromDate').change(function () {
                ChkDate();

            });

            $('#ucToDate').change(function () {
                ChkDate();

            });

        });

        function getDate() {

            $.ajax({

                url: "../common/CommonService.asmx/getDate",
                data: '{}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                    $('#<%=grdPatient.ClientID %>').hide();
                    return;
                }
            });
        }

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

                        getDate();

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');

                    }
                }
            });

        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Patient Order Set Search</b></div>
            <div style="text-align: center;">
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />&nbsp;</div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;</div>
            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                <tr>
                    <td style="width: 15%; text-align: right">
                        UHID :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <asp:TextBox ID="txtPatientID" runat="server" AutoCompleteType="Disabled" ToolTip="Enter UHID"
                            Width="176px" TabIndex="1" MaxLength="50"></asp:TextBox>
                    </td>
                    <td style="width: 15%; text-align: right">
                    </td>
                    <td style="width: 35%; text-align: left">
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right">
                        Patient Name :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled" onkeyup="check(event)"
                            TabIndex="2" ToolTip="Enter Patient Name" Width="176px" MaxLength="50" ClientIDMode="Static"></asp:TextBox>
                    </td>
                    <td style="width: 15%; text-align: right;">
                        Order Set :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left;">
                        <asp:DropDownList ID="ddlOrderSet" runat="server" Width="315px" TabIndex="10" ToolTip="Select Consultant">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right">
                        IPD No. :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <asp:TextBox ID="txtTransactionNo" runat="server" MaxLength="10" TabIndex="3" ToolTip="Enter IPD No."
                            Width="176px"></asp:TextBox>
                        
                    </td>
                    <td style="width: 15%; text-align: right">
                        Doctor :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <asp:DropDownList ID="cmbDoctor" runat="server" Width="315px" TabIndex="4" ToolTip="Select Consultant">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right">
                        From Date :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" Width="176px"
                            ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                        <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 15%; text-align: right">
                        To Date :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <asp:TextBox ID="ucToDate" runat="server" Width="176px" ClientIDMode="Static" TabIndex="6"
                            ToolTip="Click To Select To Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right">
                        Order Type :&nbsp; </td>
                    <td style="width: 35%; text-align: left">
                        
                        <asp:DropDownList ID="ddlOrderType" runat="server" BackColor="Yellow" Height="24px">
                            <asp:ListItem Selected="True">All</asp:ListItem>
                            <asp:ListItem style="display:none">Nursing</asp:ListItem>
                            <asp:ListItem style="display:none">Physio</asp:ListItem>
                            <asp:ListItem style="display:none">Nutrition</asp:ListItem>
                            <asp:ListItem>IPD Admission</asp:ListItem>
                        </asp:DropDownList>
                        
                    </td>
                    <td style="width: 15%; text-align: right">
                        &nbsp;</td>
                    <td style="width: 35%; text-align: left">
                        &nbsp;</td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="7"
                    Text="Search"  OnClick="btnSearch_Click" ToolTip="Click To Search" />
            </div>
        </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="POuter_Box_Inventory" style="text-align: center;" id="dvgv">
                    <div class="Purchaseheader">
                        Patient Details</div>
                    <div style="overflow: auto; padding: 3px; height: 274px;">
                        <asp:GridView ID="grdPatient" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdPatient_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UHID">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" Width="90px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblMRNo" Text='<%#Util.GetString(Eval("PatientID")) %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="IPD&nbsp;No.">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" Width="60px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblTransactionID" Text='<%#Util.GetString(Eval("TransactionID")).Replace("ISHHI","") %>'
                                            runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Patient Name">
                                    <ItemStyle  CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="160px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblPName" Text='<%# Eval("PatientName") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="AgeSex" HeaderText="Age/Sex">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" Width="90px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" Width="160px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="OrderSet" HeaderText="Order Set">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" Width="250px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="EntryDate" HeaderText="Date">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" Width="150px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Department" HeaderText="Department">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" Width="150px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                 <asp:BoundField DataField="IsReadNotification" HeaderText="Is Read">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" Width="150px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ReadBy" HeaderText="Read By">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" Width="150px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="View">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgbtnSticker" ToolTip="View" runat="server" ImageUrl="../../Images/view.gif"
                                            CausesValidation="false" CommandArgument='<%# Eval("TransactionID")+"#"+Eval("GroupID")+"#"+Eval("RelationalID")%>' CommandName="view" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        </asp:GridView>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="grdPatient" />
                <asp:AsyncPostBackTrigger ControlID="btnSearch" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
</asp:Content>
