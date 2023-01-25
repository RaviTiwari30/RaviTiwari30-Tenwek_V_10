<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BatchProcessReport.aspx.cs" Inherits="Design_CSSD_BatchProcessReport" Title="Untitled Page"
    EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function preventBackspace(e) {
            var evt = e || window.event;
            if (evt) {
                var keyCode = evt.charCode || evt.keyCode;
                if (keyCode === 8) {
                    if (evt.preventDefault) {
                        evt.preventDefault();
                    } else {
                        evt.returnValue = false;
                    }
                }
            }
        }
    </script>

    <script type="text/javascript">
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
                        $('#grdReport').hide();
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                        $('#btnReport').removeAttr('disabled');
                    }
                }
            });
        }
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Batch Process</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError">
            </asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtfromDate" runat="server"
                                ToolTip="Click To Select From Date" TabIndex="1"
                                ClientIDMode="Static" onKeyDown="preventBackspace();"></asp:TextBox>
                            <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtfromDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server"
                                ToolTip="Click To Select From Date" TabIndex="1"
                                ClientIDMode="Static" onKeyDown="preventBackspace();"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnSearch" Text="Search" ClientIDMode="Static" runat="server" OnClick="btnSearch_Click" CssClass="ItDoseButton" />
                        </div>
                        <div class="col-md-11">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="height: 350px; overflow: auto;">
            <asp:GridView ID="grdReport" ClientIDMode="Static" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Width="100%" OnRowCommand="grdReport_RowCommand">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                        <ItemTemplate><%# Container.DataItemIndex+1 %></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Start Date" HeaderText="Start Date">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Start Time" HeaderText="Start Time">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="End Date" HeaderText="End Date">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="End Time" HeaderText="End Time">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Boiler Name" HeaderText="Boiler Name">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Batch Name" HeaderText="Batch Name">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Name" HeaderText="User Name">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Remark" HeaderText="Remark">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="View Detail">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:ImageButton ID="imgView" ImageUrl="~/Images/view.GIF" CommandName="View" CommandArgument='<%#Eval("BatchNo")%>' runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

