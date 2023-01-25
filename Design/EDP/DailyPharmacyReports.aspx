<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DailyPharmacyReports.aspx.cs" Inherits="Design_EDP_DailyPharmacyReports" %>

<%-- Add content controls here --%>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        .divborderheader {
            border: solid thin;
            font: 15px;
            font-weight: bolder;
            padding: 3px;
        }

        .divborder {
            border: solid thin;
            padding: 3px;
            margin-top: -5px;
            height: 100px;
        }

        .divborderlowheight {
            border: solid thin;
            padding: 3px;
            margin-top: -5px;
            height: 30px;
        }
    </style>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Daily Pharmacy Reports</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Department
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlDepartment" runat="server" TabIndex="5" ClientIDMode="Static">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    Date
                </div>

                <div class="col-md-5">
                    <asp:TextBox ID="txtdatefrom" runat="server" ClientIDMode="Static" TabIndex="4"></asp:TextBox>
                    <cc1:CalendarExtender ID="calfrom" TargetControlID="txtdatefrom" Format="dd-MMM-yyyy"
                        Animated="true" runat="server">
                    </cc1:CalendarExtender>
                </div>

                <div class="col-md-8">
                    <input type="button" class="pull-right" id="btnSearch" value="Search" onclick="SearchData()" />

                    <asp:Button ID="btngetPrintData" Text="View" runat="server" OnClick="btngetPrintData_Click" class="pull-right" />

                </div>
            </div>


        </div>
        <div id="divGridView" runat="server" clientidmode="Static">

            <div class="POuter_Box_Inventory" style="text-align: center; max-height: 480px; overflow: scroll;">
                <asp:GridView AutoGenerateColumns="False" CssClass="GridViewStyle" ID="grvdetail" runat="server" Width="99%" OnRowCommand="grvdetail_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>

                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="50px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="IpdOpdCount">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblIpdOpdCount" Text='<%# Eval("IpdOpdCount") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="150px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Out Of Stock Drug">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblOutOfStockDrug" Text='<%# Eval("OutOfStockDrug") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="150px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                        </asp:TemplateField>



                        <asp:TemplateField HeaderText="Low Stock drug">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblLowStockdrug" Text='<%# Eval("LowStockdrug") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="150px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                        </asp:TemplateField>






                        <asp:TemplateField HeaderText="Drug PrescribedBut Out Of Stock">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblDrugPrescribedButOutOfStock" Text='<%# Eval("DrugPrescribedButOutOfStock") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="150px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="DDATally">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblDDATally" Text='<%# Eval("DDATally") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="150px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                        </asp:TemplateField>





                        <asp:TemplateField HeaderText="HandHoverBy">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblHandHoverBy" Text='<%# Eval("HandHoverBy") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="150px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="HandHoverTo">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblHandHoverTo" Text='<%# Eval("HandHoverTo") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="150px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="EntryDate">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblEntryDate" Text='<%# Eval("EntryDateTime") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="150px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgPrint" runat="server" ImageUrl="~/Images/print.gif" CausesValidation="false" CommandName="RePrint" CommandArgument='<%# Eval("ID")%>' />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <div id="divShowHide" style="display: none" runat="server" clientidmode="Static">
            <div class="POuter_Box_Inventory">
                <div class="row">

                    <div class="col-md-2 divborderheader GridViewHeaderStyle">Sn.</div>
                    <div class="col-md-11 divborderheader GridViewHeaderStyle">ITEM</div>
                    <div class="col-md-11 divborderheader GridViewHeaderStyle">COMMENT</div>
                </div>
                <div class="row ">
                    <div class="col-md-2 divborder GridViewItemStyle">1.</div>
                    <div class="col-md-11 divborder GridViewItemStyle">
                        No. of Pts Served
(for MCH, include pts served at lunch time,
For IP Night shift include no of OP pts
served)
                    </div>
                    <div class="col-md-11 divborder">
                        <label id="lblOpdIpdCount"></label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2 divborder">2.</div>
                    <div class="col-md-11 divborder">Out-of-stock Drugs</div>
                    <div class="col-md-11 divborder" id="divOutOfStock">
                        <label id="lblOutOfStock"></label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2 divborder">3.</div>
                    <div class="col-md-11 divborder">Low-in-stock Drugs</div>
                    <div class="col-md-11 divborder" id="divLowinstock">
                        <label id="lblLowInStock"></label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2 divborder">4.</div>
                    <div class="col-md-11 divborder">DDA Tally</div>
                    <div class="col-md-11 divborder">
                        <input type="radio" name="rblddaTally" value="Yes" id="rblYes" />
                        <label for="rblYes">Yes</label>
                        <input type="radio" name="rblddaTally" value="No" id="rblNo" />
                        <label for="rblNo">No</label>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-2 divborder">5.</div>
                    <div class="col-md-11 divborder">
                        Drugs prescribed but out of stock
                    </div>
                    <div class="col-md-11 divborder" id="divPrescribedButOutOfStock">
                        <label id="lblPrescribedButOutOfStock"></label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2 divborder">6.</div>
                    <div class="col-md-11 divborder">
                        HMIS Issues/Inventory issues e.g
stocks not tallying
                    </div>

                    <div class="col-md-11 divborder">
                        <textarea id="txtHMISIssue" class="required" style="height: 90px" cols="10" rows="2"></textarea>
                        />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2 divborder">7.</div>
                    <div class="col-md-11 divborder">
                        Special Order Drugs (Name of drug,
dosage, quantity needed, time
frame)
                    </div>
                    <div class="col-md-11 divborder">
                        <textarea id="txtSpecialDrug" class="required" style="height: 90px" cols="10" rows="2"></textarea>

                    </div>
                </div>

                <div class="row">
                    <div class="col-md-2 divborder">8.</div>
                    <div class="col-md-11 divborder">
                        Handed over by_to_  ,
Or Written by
                    </div>
                    <div class="col-md-11 divborder">
                        <div class="col-md-12">
                            <input type="checkbox" id="chkIsHandhover" onclick="chkHandOverclick()" />
                        </div>
                        <div class="col-md-12" id="divhandoverto">
                            <select id="ddlHandHoverTo"></select>
                        </div>

                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2 divborder">9.</div>
                    <div class="col-md-11 divborder">Remarks</div>
                    <div class="col-md-11 divborder">
                        <textarea id="txtRemarks"  style="height: 90px" cols="10" rows="2"></textarea>
                    </div>
                </div>
                <div class="row">

                    <div class="col-md-24 divborderlowheight" style="text-align: center">*NB: For items that are not applicable, kindly note N/A</div>
                </div>
                <div class="row">

                    <div class="col-md-24 divborderlowheight" style="text-align: center">
                        <input type="button" id="btnSave" value="Save" onclick="Save()" />
                    </div>
                </div>


            </div>

        </div>

    </div>

    <script type="text/javascript">
        $(document).ready(function () {

            hide();
            ddlHandOverShowHide(0);
        });

        function chkHandOverclick() { 
            if ($('#chkIsHandhover').is(":checked")) {
                ddlHandOverShowHide(1);
            } else {
                ddlHandOverShowHide(0);
            }
        }


        function ddlHandOverShowHide(Type) {
            if (Type == 0) {
                $("#divhandoverto").hide();
            } else {
                $("#divhandoverto").show();
            }
        }


        function Show() {
            $("#divShowHide").show();

            $("#divGridView").hide();
        }
        function hide() {

            $("#divShowHide").hide();
        }
        function SearchData() {

            var DeptLedNo = $("#ddlDepartment ").val();
            var FromDate = $("#txtdatefrom ").val();
            serverCall('DailyPharmacyReports.aspx/GetDataToFill', { DepLedgerNo: DeptLedNo, Date: FromDate }, function (response) {


                var GetData = JSON.parse(response);

                if (GetData.status == "2") {

                    $('#lblOpdIpdCount').text(GetData.IpdOpdCount);
                    $('#lblOutOfStock').text(GetData.OutOfStock);
                    $('#lblLowInStock').text(GetData.LowInstock);
                    $('#lblPrescribedButOutOfStock').text(GetData.PrescribedButOutOfStock);

                    Show();

                }
                else if (GetData.status == "1") {

                    $('#lblOpdIpdCount').text(GetData.IpdOpdCount);
                    $('#lblOutOfStock').text(GetData.OutOfStock);
                    $('#lblLowInStock').text(GetData.LowInstock);
                    $('#lblPrescribedButOutOfStock').text(GetData.PrescribedButOutOfStock);
                    $ddlHandHoverTo = $('#ddlHandHoverTo');
                    $ddlHandHoverTo.bindDropDown({ defaultValue: 'Select', data: GetData.HandHoverTo, valueField: 'EmpName', textField: 'EmpName', isSearchAble: true });


                    Show();
                } else {
                    hide();
                }

            });
        }

        var Save = function () {
            var data = {
                IpdOpdCount: $('#lblOpdIpdCount').text(),
                OutOfStockDrug: $('#lblOutOfStock').text(),
                LowStockdrug: $('#lblLowInStock').text(),
                DDATally: $("input[name='rblddaTally']:checked").val(),
                DrugPrescribedButOutOfStock: $('#lblPrescribedButOutOfStock').text(),
                HMISIssues: $('#txtHMISIssue').val(),
                SpecialOrder: $('#txtSpecialDrug').val(),
                HandHoverTo: $("#ddlHandHoverTo").val(),
                Signature: "",
                DeptLedgerNo: $("#ddlDepartment ").val(),
                DeptName: $("#ddlDepartment option:selected").text(),
                Remarks: $('#txtRemarks').val(),
                SelectedDate : $("#txtdatefrom ").val(),
            }
            if (data.DDATally == "" || data.DDATally == undefined) {
                modelAlert("Select DDA Tally.");
                return false;
            }
            if (data.SpecialOrder == "" || data.SpecialOrder == undefined) {
                modelAlert("Enter Special Drug.");
                return false;
            }
            if (data.HMISIssues == "" || data.HMISIssues == undefined) {
                modelAlert("Enter HMIS Issues/Inventory issues e.g stocks not tallying.");
                return false;
            }

            if (data.HandHoverTo == "0" || data.HandHoverTo == undefined) {
                data.HandHoverTo = "";
            }

            serverCall('DailyPharmacyReports.aspx/SaveDailyData', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        GetOrderData()
                        $closeRestartModel();
                    }
                });
            });
        }


    </script>
</asp:Content>
