<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ViewBreakDownRequest.aspx.cs" Inherits="Design_HelpDesk_ViewBreakDownRequest" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style>
        .Disabl {
            display:none;
        }
    </style>
    <script type="text/javascript">
        function Validate() {
            if ($('#<%=ddlDepartment.ClientID %>').val() == "0") {
                modelAlert("Select Department");
                $('#<%=ddlDepartment.ClientID %>').focus();
                return false;
            }
            if ($('#<%=ddlErrorType.ClientID%>').val() == "0") {
             //   modelAlert("Select Error Type");
           //     $('#<%=ddlErrorType.ClientID %>').focus();
           //      return true;
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>View BreakDown Request </b>
            <br />
            <asp:Label ID="lblErrormsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                View BreakDown Request  &nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Department</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="requiredField"  OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">Error Type</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                           <asp:DropDownList ID="ddlErrorType" runat="server" CssClass="requiredField" OnSelectedIndexChanged="ddlErrorType_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Asset Name</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                           <asp:DropDownList ID="ddlAssetName" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate"  runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date" CssClass="requiredField" autocomplete="off"></asp:TextBox>
                            <cc1:calendarextender id="ToDatecal" targetcontrolid="txtFromDate" format="dd-MMM-yyyy"
                                animated="true" runat="server">
                            </cc1:calendarextender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate"  runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date" CssClass="requiredField" autocomplete="off"></asp:TextBox>
                                    <cc1:calendarextender id="Calendarextender1" targetcontrolid="txtToDate" format="dd-MMM-yyyy"
                                        animated="true" runat="server">
                                    </cc1:calendarextender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Status</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlStatus" runat="server">
                                <asp:ListItem Value="6">All</asp:ListItem>
                                <asp:ListItem Value="1">Assigned</asp:ListItem>
                                <asp:ListItem Value="2">Viewed</asp:ListItem>
                                <asp:ListItem Value="3">Visited</asp:ListItem>
                                <asp:ListItem Value="7">Processed</asp:ListItem>
                                <asp:ListItem Value="4">Resolved</asp:ListItem>
                                <asp:ListItem Value="5">Closed</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>

            
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
           <%-- <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <Triggers>
                    <asp:asyncpostbacktrigger controlid="btnSearch" eventname="click"/>
                </Triggers>
                <ContentTemplate>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="ItDoseButton" />
                </ContentTemplate>
            </asp:UpdatePanel>--%>
            
           <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" OnClientClick="javascript:return Validate()" CssClass="ItDoseButton" />
            
        </div>

        <div class="POuter_Box_Inventory">
        <table style="width: 100%; border-collapse: collapse">
            <tr>
                <td colspan="4" style="text-align: left">
                    <asp:UpdatePanel ID="Up2" runat="server">
                        <ContentTemplate>
                            <asp:GridView runat="server" ID="dgGrid" DataKeyNames="TicketID" OnRowDataBound="dgGrid_RowDataBound" AutoGenerateColumns="false" CssClass="GridViewStyle" OnRowCommand="dgGrid_RowCommand">
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="From Dept">
                                        <ItemTemplate>
                                            <%#Eval("RoleName") %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Error Type">
                                        <ItemTemplate>
                                            <%#Eval("Error_type") %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Asset Name">
                                        <ItemTemplate>
                                            <%#Eval("AssetName") %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Date">
                                        <ItemTemplate>
                                            <%#Eval("Date") %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Current Status">
                                        <ItemTemplate>
                                            <asp:Label ID="lblLastStatus" runat="server"></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Change Status To">
                                        <ItemTemplate>
                                            <asp:Button ID="btnView" Text='<%#Eval("btnText") %>' runat="server" CausesValidation="false" CommandName='<%#Eval("AssignedBy") %>' CommandArgument='<%#Eval("StockID") %>' Width="80px" CssClass='<%#Eval("Display") %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <center>
                        <asp:Label ID="lblMsg" runat="server"></asp:Label>
                    </center>
                </td>
            </tr>
        </table>
    </div>

        <div class="POuter_Box_Inventory" id="tblDetails" style="display:none;">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Asset Name :</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblname" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Model No. :</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblModel" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Warrenty Status :</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblWarrentystatus" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Warrenty To :</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblWarrentyTo" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Vendor :</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblVendor" runat="server"></asp:Label>
                        </div>
                        
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">AMC Status :</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblAmcStatus" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">AMC To :</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblAMCTo" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">AMC Vendor :</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblAMCVendor" runat="server"></asp:Label>
                        </div>
                        
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">CMC Status :</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblCMCStatus" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">CMC To :</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblCMCTo" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">CMC Vendor :</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblCMCVendor" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <span id="spnbreak">Break Down Resolve Type :</span>
                            <span id="spnStatus" style="display:none">Status :</span>
                            <asp:Label id="IDstatus" runat="server" Visible="false"></asp:Label>
                        </div>
                        <div class="col-md-5">
                            <asp:HiddenField runat="server" ID="hfTicketID" />
                            <asp:HiddenField runat="server" ID="hfAssigned" />
                            <asp:RadioButtonList ID="rbtnresolve" runat="server" RepeatDirection="Horizontal">
                               <%-- <asp:ListItem Value="1">Under Warrenty</asp:ListItem>
                                <asp:ListItem Value="2">Under AMC</asp:ListItem>
                                <asp:ListItem Value="3">Under CMC</asp:ListItem>
                                <asp:ListItem Value="4">On Call Vendor</asp:ListItem>--%>
                                <asp:ListItem Value="1">On Site</asp:ListItem>
                                <asp:ListItem Value="2">Entimate to HOD</asp:ListItem>
                            </asp:RadioButtonList>
                            
                        </div>
                    </div>
                </div>
            </div>
        
    </div>

  <div class="POuter_Box_Inventory" id="tblEnterActualError" style="display:none;">
        <table width="50%" style="margin:auto;">
            <tr>
                <td>
                    Actual Error Type: 
                </td>
                <td style="width:300px;">
                    <asp:DropDownList ID="ddlActualError" runat="server" Width="300px">
                    </asp:DropDownList>
                </td>
                <td>
                    <input type="button" value="New" id="btnNewActualError" />
                </td>
            </tr>
            <tr>
                <td>
                    Comment :
                </td>
                <td colspan="2">
                    <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" CssClass="requiredField" Height="60px" Width="300px" ></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <center>
                        <input type="button" value="Resolved" id="btnResolved" />
                    </center>
                </td>
            </tr>
        </table>
    </div>

    <div class="POuter_Box_Inventory" id="tblHOD" style="display:none;">
        <table id="" style="width:50%;margin:auto;">
            <tr>
                <td>
                    Actual Error Type :
                </td>
                <td style="width:300px;">
                    <asp:DropDownList ID="ddlHODError" runat="server"></asp:DropDownList>
                </td>
                <td>
                    <input type="button" value="New" id="btnNewHODError" />
                </td>
            </tr>
            <tr>
                <td>
                    Assigned To :
                </td>
                <td>
                    <asp:HiddenField ID="hfAssign" runat="server" />
                    <asp:Label ID="lblAssignedTo" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    Comment :
                </td>
                <td>
                    <asp:TextBox ID="txtHODComment" runat="server" TextMode="MultiLine" CssClass="requiredField" Height="60px" Width="300px" ></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                   <center> <input type="button" value="Entimate to HOD" id="btnHOD" /></center>
                </td>
            </tr>
        </table>
    </div>
    </div>

    

    

    <!----------------------------Modal Popup start-------------------------------------------------->
    <div id="myModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="height:130px;width:350px;padding:4px;">
                <div class="modal-header">
                  <button type="button" class="close" aria-hidden="true" onclick="CloseModalPopup()">&times;</button>
                  <h4 class="modal-title">Add New Error</h4>
                </div>
                <div>
                    <table>
                        <tr>
                            <td>
                                Enter New Error :
                            </td>
                            <td>
                                <input type="text" id="txtEnterNewError" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <center>
                                    <input type="button" value="Save" id="btnSaveNewError" />
                                </center>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!----------------------------END-------------------------------------------------->

    <script type="text/javascript">
        function tempAlert(msg, duration) {
            var el = document.createElement("div");
            el.setAttribute("style", "position:absolute;top:40%;left:44%;background-color:#3278b5;width:100px;height:30px;text-align:center;z-index:1500;line-height:25px;color:#ffffff;border-radius:8px;");
            el.innerHTML = msg;
            setTimeout(function () {
                el.parentNode.removeChild(el);
            }, duration);
            document.body.appendChild(el);
        }

        $("#btnResolved").click(function () {
            var Errorname = $("#<%=ddlActualError.ClientID%> option:selected").text();
            var Errorid = $("#<%=ddlActualError.ClientID%> option:selected").val();
            var Ticketid = $('[id$=hfTicketID]').text();
            var status = "Resolved";
            var comment = $('[id$=txtComment]').val();

            $.ajax({
                url: 'ViewBreakDownRequest.aspx/SaveErrorStatus',
                data: '{errorname:"' + Errorname + '",errorid:"' + Errorid + '",ticketid:"' + Ticketid + '",errorstatus:"' + status + '",comments:"' + comment + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (r) {
                $('[id$=txtComment]').val("");
                modelAlert("Successfully Saved");
                $("#tblDetails").css("display", "none");
                $("#tblEnterActualError").css("display", "none");
                $("#tblHOD").css("display", "none");
               // tempAlert("Successfully Saved", 2000);
            });
        });

        $("#btnHOD").click(function () {
            var Errorname = $("#<%=ddlHODError.ClientID%> option:selected").text();
            var Errorid = $("#<%=ddlHODError.ClientID%> option:selected").val();
            var Ticketid = $('[id$=hfTicketID]').text();
            var status = "Entimate to HOD";
            var comment = $('[id$=txtHODComment]').val();
            var assignId = $('[id$=hfAssign]').text();
            var assignBy=$('[id$=lblAssignedTo]').text();

            $.ajax({
                url: 'ViewBreakDownRequest.aspx/SaveHODErrorStatus',
                data: '{errorname:"' + Errorname + '",errorid:"' + Errorid + '",ticketid:"' + Ticketid + '",errorstatus:"' + status + '",comments:"' + comment + '",AssignId:"' + assignId + '",AssignBy:"' + assignBy + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (r) {
                $('[id$=txtHODComment]').val("");
                modelAlert("Successfully Saved");
                $("#tblDetails").css("display", "none");
                $("#tblEnterActualError").css("display", "none");
                $("#tblHOD").css("display", "none");
               // tempAlert("Successfully Saved", 2000);
            });

        });

        $("#btnNewActualError, #btnNewHODError").click(function () {
            ShowModalPopupp();
        });

        $("#btnSaveNewError").click(function () {
            var newError = $("#txtEnterNewError").val();

            if (newError == "") {
                alert("Enter error name...");
            }
            else {
                $.ajax({
                    url: 'ViewBreakDownRequest.aspx/SaveNewError',
                    data: '{Error:"' + newError + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    type: "POST",
                }).done(function (r) {
                    $("#txtEnterNewError").val("");
                    CloseModalPopup();
                    tempAlert("Error Saved", 2000);

                    var id = JSON.parse(r.d);
                    
                    var newoption = "<option value='" + id + "'>" + newError + "</option>";
                    $('[id$=ddlHODError]').append(newoption);
                    $('[id$=ddlActualError]').append(newoption);
                });
            }
        });

        function ShowModalPopupp() {
            $("#myModal").show();

            // alert(selectedvals);
        }
        function CloseModalPopup() {
            $("#myModal").hide();
        }


        $("#<%=rbtnresolve.ClientID%>").change(function () {
            var value = $("input[name='<%=rbtnresolve.UniqueID%>']:radio:checked").val();
            var ticketid = $('[id$=hfTicketID]').text();
            SaveVisit(ticketid);

            if (value == 1) {
                $("#tblEnterActualError").css("display", "");
                $("#tblHOD").css("display", "none");
            }
            else {
                var assign = $('[id$=hfAssigned]').text();
                $.ajax({
                    url: 'ViewBreakDownRequest.aspx/GetEmployeeNameByEmpID',
                    data: '{empID:"' + assign + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    type: "POST",
                }).done(function (r) {
                    var res = JSON.parse(r.d);
                    $('[id$=lblAssignedTo]').text(res);
                    $('[id$=hfAssign]').text(assign);
                });
                $("#tblEnterActualError").css("display", "none");
                $("#tblHOD").css("display", "");
            }
        });

        function SaveVisit(ticket) {
            $.ajax({
                url: 'ViewBreakDownRequest.aspx/UpdateVisit',
                data: '{ticketID:"' + ticket + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (r) {

            });
        }

        function CheckLastVisit(ticketid) {
            $.ajax({
                url: 'ViewBreakDownRequest.aspx/CheckLastStatusVisited',
                data: '{ticketId:"' + ticketid + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (data) {
                var r = JSON.parse(data.d);
               // alert("R= " + r);

                if (r > 0) {
                    $("#spnbreak").css("display", "none");
                    $("#<%=rbtnresolve.ClientID%>").css("display", "none");

                    $("#spnStatus").css("display", "");
                }
                else {
                    $("#spnbreak").css("display", ""); $("#<%=rbtnresolve.ClientID%>").css("display", "");
                    $("#spnStatus").css("display", "none");
                }
            });
        }

        function ShowAssetDetails(stockId, Ticketid,AssignedId) {
            $('[id$=hfTicketID]').text(Ticketid);
            $('[id$=hfAssigned]').text(AssignedId);
            $.ajax({
                url: 'ViewBreakDownRequest.aspx/BindAssetDetails',
                data: '{stockID:"' + stockId + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (data) {
                if (data.d != '') {
                    $('[id$=lblname]').text(data.d[0]);
                    $('[id$=lblModel]').text(data.d[2]);
                    $('[id$=lblWarrentystatus]').text(data.d[3]);
                    $('[id$=lblWarrentyTo]').text(data.d[4]);
                    $('[id$=lblVendor]').text(data.d[5]);
                    $('[id$=lblAmcStatus]').text(data.d[6]);
                    $('[id$=lblAMCVendor]').text(data.d[7]);
                    $('[id$=lblCMCStatus]').text(data.d[8]);
                    $('[id$=lblCMCVendor]').text(data.d[9]);
                    $('[id$=lblCMCTo]').text(data.d[15]);
                    $('[id$=lblAMCTo]').text(data.d[16]);
                    // $('[id$=lblamcno]').text(data.d[12]);
                    // $('[id$=lblCMCNo]').text(data.d[13]);
                    // $('[id$=lblCMCDate]').text(data.d[14]);
                    //$('[id$=hfStockID]').text(data.d[1]);

                    CheckLastVisit(Ticketid);

                    $("#tblDetails").css("display", "");
                }
                else {
                    $("#tblDetails").css("display", "none");
                }
            });
        }
    </script>
</asp:Content>

