<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CoverNoteReprint.aspx.cs" Inherits="Design_Dispatch_CoverNoteReprint" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        $(function () {

            $("#ddlPanelCompany").chosen();

            $('#ucFromDate').change(function () {
                ChkDate();
            });
            $('#ucToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $("span[id*='lblMsg']").text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $("span[id*='lblMsg']").text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }

    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            var headerChk = $(".chkHeader input");
            var itemChk = $(".chkItem input");
            headerChk.click(function () {
                itemChk.each(function () {
                    this.checked = headerChk[0].checked;
                })
                $("#<%=gvItems.ClientID %> tr").each(function () {
                    if (!this.rowIndex)
                        return;
                    if ($.trim($(this).closest("tr").find("span[id*='lblCoverNote']").text()).length == 0)
                        $(this).closest("tr").find("[id*='chkSelect']").removeAttr("checked");
                });
            });
            itemChk.each(function () {
                $(this).click(function () {
                    if (this.checked == false) { headerChk[0].checked = false; }
                })
            });
        });

        $("[id*=chkBoxAll]").live("click", function () {
            var chkHeader = $(this);
            var grid = $(this).closest("table");
            $("input[type=checkbox]", grid).each(function () {
                if (chkHeader.is(":checked")) {
                    $(this).not(":disabled").attr("checked", "checked");

                } else {
                    $(this).not(":disabled").removeAttr("checked");

                }
            });
        });
        $("[id*=chkBox]").live("click", function () {
            var grid = $(this).closest("table");
            var chkHeader = $("[id*=chkBoxAll]", grid);
            if (!$(this).is(":checked")) {
                chkHeader.removeAttr("checked");
            } else {
                var totalRow = (($("[id*=chkBox]", grid).length) - 1);
                var disableRow = (totalRow - ($("[id*=chkBox]:checked", grid).not(":disabled").length));
                if (($("[id*=chkBox]", grid).not(":disabled").length - 1) == $("[id*=chkBox]:checked", grid).not(":disabled").length) {
                    chkHeader.attr("checked", "checked");
                }
            }
        });

    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center">
                <b>Cover Note Reprint</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Searching Criteria </div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMRNo" TabIndex="1" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientName" TabIndex="2" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Cover Note No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCoverNoteNo" TabIndex="3" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Panel
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanelCompany" runat="server" ClientIDMode="Static" TabIndex="4" ToolTip="Select Panel"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList RepeatDirection="Horizontal" RepeatLayout="Flow" runat="server" ID="rblType" TabIndex="5">
                                <asp:ListItem Selected="True" Value="OPD">OPD</asp:ListItem>
                                <asp:ListItem Value="EMG">Emergency</asp:ListItem>
                                <asp:ListItem Value="IPD">IPD</asp:ListItem>
                            </asp:RadioButtonList>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD/EMG No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTransNo" TabIndex="6" runat="server"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" TabIndex="7" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" TabIndex="8" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" CssClass="ItDoseButton" OnClick="btnSearch_Click" ClientIDMode="Static" TabIndex="9" Text="Search" runat="server" />
        </div>
        <div runat="server" id="divShow" visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Patient Cover Note Deatalis </div>
                <div id="Div7" class="content" runat="server" style="text-align: center; height: 380px; overflow: auto; width: 100%">
                    <asp:GridView ID="gvItems" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" Width="99%" OnRowCommand="gvItems_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>

                            <asp:TemplateField HeaderText="Sr.No">
                                <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1  %>
                                </ItemTemplate>
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="Type">
                                <ItemTemplate>
                                    <asp:Label ID="lblType" runat="server" Text=' <%# Eval("Type") %>' ClientIDMode="Static"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Company">
                                <ItemTemplate>
                                    <%# Eval("PanelName") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Cover Note No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblCoverNote" runat="server" Text=' <%# Eval("CoverNoteNo") %>' ClientIDMode="Static"></asp:Label>

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Cover Note Date">
                                <ItemTemplate>
                                    <%# Eval("CoverNoteDate") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Patient Name">
                                <ItemTemplate>
                                    <%# Eval("PatientName") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="UHID">
                                <ItemTemplate>
                                    <%# Eval("PatientID") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="100px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Bill No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblBillNo" runat="server" Text=' <%# Eval("BillNo") %>' ClientIDMode="Static"></asp:Label>

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="IPD/EMG No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblTransNo" runat="server" Text=' <%# Eval("TransNo") %>' ClientIDMode="Static"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Print">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgPrint" runat="server" ImageUrl="~/Images/print.gif" AccessKey="p" CommandName="print" CommandArgument='<%# Eval("CoverNoteNo")+"#"+Eval("Type") %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="30px" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>

                </div>
            </div>
        </div>
    </div>
</asp:Content>
