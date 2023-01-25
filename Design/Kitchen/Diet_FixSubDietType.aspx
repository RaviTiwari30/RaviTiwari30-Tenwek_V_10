<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Diet_FixSubDietType.aspx.cs" Inherits="Design_Kitchen_Diet_FixSubDietType" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function ViewComponent(objRef) {
            var row = objRef.parentNode.parentNode;
            var DietTimeID = $('#<%=ddlDietTiming.ClientID %>').val();
            var subDietID = $(row).find('#ddlSubDiet').val();
            var MenuID = $(row).find('#ddlMenu').val();

            var IPDCaseTypeID = $(row).find('#lblIPDCaseTypeID').text();
            var PanelID = $(row).find('#lblPanelID').text();

            if (subDietID == '0' || MenuID == '0') {
                modelAlert("Please Select SubDiet and Menu");
                return;
            }
            $.ajax({
                url: "Diet_FixSubDietType.aspx/getComponent",
                data: JSON.stringify({ DietTimeID: DietTimeID, subDietID: subDietID, MenuID: MenuID, IPDCaseTypeID: IPDCaseTypeID, PanelID: PanelID }),
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var resultObj = jQuery.parseJSON(mydata.d);
                    var resultDiv = "<div style='text-align: right; position: absolute; right:2px; top:2px'><img alt='Close' src='../../Images/Delete.gif' style='cursor:pointer' onclick='HideDivComponent();' /></div><div id='Pbody_box_inventory' style='width:100%;'>";
                    resultDiv += "<div style='text-align: center; width: 99%;' class='POuter_Box_Inventory'><b>Component Detail</b></div>";
                    resultDiv += "<div class='POuter_Box_Inventory' style='width: 99%;'> <table class='GridViewStyle' style='width: 100%'><tr class='GridViewHeaderStyle'><th style='width: 5%;text-align: center'>S.No.</th><th style='width: 55%;text-align: left'>Component</th><th style='width: 10%'>Rate</th><th style='width: 10%'>Qty.</th><th style='width: 10%'>Type</th><th style='width: 10%'>Unit</th><th style='width: 10%'>Calories</th><th style='width: 10%'>Protein</th><th style='width: 10%'>Sodium</th><th style='width: 10%'>SaturatedFat</th><th style='width: 10%'>T_Fat</th><th style='width: 10%'>Calcium</th><th style='width: 10%'>Iron</th><th style='width: 10%'>zinc</th></tr>";
                    for (var i = 0; i < resultObj.length; i++) {
                        resultDiv += "<tr class='GridViewItemStyle'><td style='width: 5%;text-align: center'>" + (i + 1) + "</td><td style='width: 55%'> " + resultObj[i].ComponentName + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Rate + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Qty + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Type + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Unit + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Calories + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Protein + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Sodium + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].SaturatedFat + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].T_Fat + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Calcium + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].Iron + "</td><td style='width: 10%;text-align: center'>" + resultObj[i].zinc + "<br /></td></tr>";
                    }
                    resultDiv += "</table></div></div>"
                    $('#divComponent').html(resultDiv);
                    $('#divComponent').show();
                },
                error: function (error) {
                    modelAlert('Error: ', jQuery.parseJSON(error.d));
                }
            });
        }
        function HideDivComponent() {
            $('#divComponent').hide();
        }
        function RefreshGrid() {
            $('#<%=grdPatientDiet.ClientID%>').html('');
        }
        function ViewHistory(objRef) {
            var row = objRef.parentNode.parentNode;
            var DietTimeID = $('#<%=ddlDietTiming.ClientID %>').val();
            var TransactionID = $(row).find('#lblTID').text();
            $.ajax({
                url: "patient_diet_request.aspx/getHistory",
                data: JSON.stringify({ DietTimeID: DietTimeID, TransactionID: TransactionID }),
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var resultObj = jQuery.parseJSON(mydata.d);
                    var resultDiv = "<div style='text-align: right; position: absolute; right:5px; top:2px'><img alt='Close' src='../../Images/Delete.gif' style='cursor:pointer' onclick='HideDivHistory();' /></div><div id='Pbody_box_inventory' style='width:528px;'>";
                    resultDiv += "<div style='text-align: center; width: 99%;' class='POuter_Box_Inventory'><b>Diet History</b></div>";
                    resultDiv += "<div class='POuter_Box_Inventory' style='width: 99%;'> <table class='GridViewStyle' style='width: 100%'><tr class='GridViewHeaderStyle'><th style='width: 5%;text-align: center'>S.No.</th><th style='width: 20%;text-align: left'>Sub Diet Type</th><th style='width: 20%'>Menu</th><th style='width: 20%'>Entry Date</th><th style='width: 20%'>Entry By</th>";
                    for (var i = 0; i < resultObj.length; i++) {
                        resultDiv += "<tr class='GridViewItemStyle'><td style='width: 5%;text-align: center'>" + (i + 1) + "</td><td style='width: 20%'> " + resultObj[i].SubDietType + "</td><td style='width: 20%;text-align: center'>" + resultObj[i].Menu + "</td><td style='width: 20%;text-align: center'>" + resultObj[i].EnterDate + "</td><td style='width: 20%;text-align: center'>" + resultObj[i].EnterBy + "<br /></td></tr>";
                    }
                    resultDiv += "</table></div></div>"
                    $('#divHistory').html(resultDiv);
                    $('#divHistory').show();
                },
                error: function (error) {
                    modelAlert('Error: ', jQuery.parseJSON(error.d));
                }
            });
        }
        function HideDivHistory() {
            $('#divHistory').hide();
        }
        function validate() {
            if ($("#<%=ddlDietTiming.ClientID%>").val() == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Diet Timing');
                modelAlert('Please Select Diet Timing')
                $("#<%=ddlDietTiming.ClientID%>").focus();
                return false;
            }
        }
    </script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div style="text-align: center" class="POuter_Box_Inventory">
            <b>Patient Diet Request</b>
            <br />
            <asp:Label ID="lblMsg" CssClass="ItDoseLblError" runat="server" style="display:none;"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Ward
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlWard" onchange="RefreshGrid();" runat="server"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Diet Timing
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDietTiming" onchange="RefreshGrid();" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnSearch" OnClientClick="return validate()" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" />
                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                         <div class="col-md-9"></div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: LightCyan;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Fixed</b>
                        </div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: white;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Pending</b>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="overflow-y: scroll; height: 400px">
            <asp:GridView ID="grdPatientDiet" HeaderStyle-CssClass="GridViewHeaderStyle" AutoGenerateColumns="false" RowStyle-CssClass="GridViewItemStyle" Width="100%" runat="server" OnRowDataBound="grdPatientDiet_RowDataBound">
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="2%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="UHID">
                        <ItemTemplate>
                            <asp:Label ID="lblMRNo" Width="100%" runat="server" Text='<%#Eval("PatientID") %>'></asp:Label>
                            <asp:Label ID="lblIPDCaseTypeID" ClientIDMode="Static" Width="100%" Style="display: none" runat="server" Text='<%#Eval("IPDCaseTypeID") %>'></asp:Label>
                            <asp:Label ID="lblPanelID" ClientIDMode="Static" Width="100%" runat="server" Style="display: none" Text='<%#Eval("PanelID") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="IPD No.">
                        <ItemTemplate>
                            <asp:Label ID="lblIPDNo" Width="100%" runat="server" Text='<%#Eval("IPDNo") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="5%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Patient Name">
                        <ItemTemplate>
                            <asp:Label ID="lblPName" runat="server" Width="100%" Text='<%#Eval("PName") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="15%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Diet Type">
                        <ItemTemplate>
                            <asp:DropDownList ID="ddlDietType" ClientIDMode="Static" Width="100%" runat="server" OnSelectedIndexChanged="ddlDietType_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="15%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Sub Diet">
                        <ItemTemplate>
                            <asp:DropDownList ID="ddlSubDiet" ClientIDMode="Static" OnSelectedIndexChanged="ddlSubDiet_SelectedIndexChanged" AutoPostBack="true" Width="100%" runat="server"></asp:DropDownList>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="15%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Menu">
                        <ItemTemplate>
                            <asp:DropDownList ID="ddlMenu" Enabled="false" ClientIDMode="Static" Width="85%" runat="server"></asp:DropDownList>
                            <img id="imgComponent" src="../../Images/view.GIF" alt="View" style="cursor: pointer" onclick="ViewComponent(this);" />
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="15%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Remarks">
                        <ItemTemplate>
                            <asp:TextBox ID="txtRemarks" runat="server" Width="95%" Text='<%#Eval("Remarks") %>'></asp:TextBox>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="15%" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <HeaderTemplate>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblDeitID" Width="100%" runat="server" Visible="false" Text='<%#Eval("DietID") %>'></asp:Label>
                            <asp:Label ID="lblSubDietID" Width="100%" runat="server" Visible="false" Text='<%#Eval("SubDietID") %>'></asp:Label>

                            <asp:Label ID="lblDietMenuID" Width="100%" runat="server" Visible="false" Text='<%#Eval("DietMenuID") %>'></asp:Label>
                            <asp:Label ID="lblID" Width="100%" runat="server" Visible="false" Text='<%#Eval("ID") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="5%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="History">
                        <ItemTemplate>
                            <img id="imgHistory" src="../../Images/view.GIF" alt="View" style="cursor: pointer" onclick="ViewHistory(this);" />
                            <asp:Label ID="lblTID" Width="100%" ClientIDMode="Static" Style="display: none" runat="server" Text='<%#Eval("TransactionID") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="5%" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <div style="text-align: center" class="POuter_Box_Inventory">
            <asp:Button ID="btnSave" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click" />
        </div>
        <div id="divComponent" class="POuter_Box_Inventory" style="display: none; border: medium; border: 2px solid black; padding: 15px; font-size: 15px; -moz-box-shadow: 0 0 5px #ff0000; -webkit-box-shadow: 0 0 5px #ff0000; box-shadow: 0 0 5px #ff0000; _position: absolute; background: #F5F5F5; width: 800px; left: 50px; top: 150px; z-index: 100; margin-left: 15px; position: fixed;">
        </div>
        <div id="divHistory" class="POuter_Box_Inventory" style="display: none; border: medium; border: 2px solid black; padding: 15px; font-size: 15px; -moz-box-shadow: 0 0 5px #ff0000; -webkit-box-shadow: 0 0 5px #ff0000; box-shadow: 0 0 5px #ff0000; _position: absolute; background: #F5F5F5; width: 550px; left: 50px; top: 150px; z-index: 100; margin-left: 150px; position: fixed;">
        </div>
    </div>
</asp:Content>
