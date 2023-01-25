<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="BloodPost.aspx.cs" Inherits="Design_BloodBank_BloodPost" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
          <script type="text/javascript" src="../../Scripts/Message.js"></script>
       <script type="text/javascript">
        $(document).ready(function () {
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
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Blood Record Search</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
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
                                Organisation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlOrg" runat="server">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Component
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList runat="server" ID="ddlComponent">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlBloodGroup" runat="server">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                 Bag Number
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtbatchno" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="Todatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            &nbsp;&nbsp;
            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton" OnClick="btnSearch_Click"
                ClientIDMode="Static" />
        </div>
        <asp:Panel ID="pnlgrdStock" runat="server" Visible="false">
            <div runat="server" class="POuter_Box_Inventory" style="text-align: center;">
                <div class="" style="text-align: center; padding-top: 5px; overflow: auto;">
                    <asp:GridView ID="grdStock" runat="server" CssClass="GridViewStyle" Width="100%" AutoGenerateColumns="false"
                        OnRowCommand="grdStock_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Collection ID">
                                <ItemTemplate>
                                    <asp:Label ID="lblCollection" runat="server" Text='<%#Eval("bb_directstockID") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewAltItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Organisation">
                                <ItemTemplate>
                                    <asp:Label ID="lblorg" runat="server" Text='<%#Eval("Organisation") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewAltItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Bill No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblbillno" runat="server" Text='<%#Eval("Bill_no") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewAltItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Bill Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblbillDate" runat="server" Text='<%#Eval("billdate") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewAltItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Created Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblCreatedDate" runat="server" Text='<%#Eval("CreatedDate") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewAltItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Created By">
                                <ItemTemplate>
                                    <asp:Label ID="lblCreatedby" runat="server" Text='<%#Eval("CreatedBy") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewAltItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="170px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Detail">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false"
                                        CommandArgument='<%# Eval("bb_directstockID")%>' CommandName="View" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewAltItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="grdhide" runat="server" Visible="false">
            <div runat="server" class="POuter_Box_Inventory" style="text-align: center;">
                <asp:GridView ID="grdStockDetails" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewAltItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Component Name">
                            <ItemTemplate>
                                <asp:Label ID="lblComponent" runat="server" Text='<%#Eval("ComponentName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewAltItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag Type" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblBagType" runat="server" Text='<%#Eval("BagType") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewAltItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Blood Group">
                            <ItemTemplate>
                                <asp:Label ID="lblBloodGrup" runat="server" Text='<%#Eval("BloodGroup") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewAltItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag Number">
                            <ItemTemplate>
                                <asp:Label ID="lblTube" runat="server" Text='<%#Eval("BBTubeNo") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewAltItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Rate">
                            <ItemTemplate>
                                <asp:Label ID="lblRate" runat="server" Text='<%#Eval("Rate") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewAltItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryDate" runat="server" Text='<%#Eval("EntryDate") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewAltItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Expiry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblExpiryDate" runat="server" Text='<%#Eval("ExpiryDate") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewAltItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <%--<asp:TemplateField HeaderText="Batch No.">
                            <ItemTemplate>
                                <asp:Label ID="lblBatch" runat="server" Text='<%#Eval("Batchno") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewAltItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>--%>
                    </Columns>
                </asp:GridView>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
