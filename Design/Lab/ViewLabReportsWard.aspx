<%@ Page Language="C#" AutoEventWireup="true"
    CodeFile="ViewLabReportsWard.aspx.cs" Inherits="Design_OPD_ViewLabReportsWard" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lab Result</title>
    <%--<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />--%>
     <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/Common.js" type="text/javascript"></script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js" type="text/javascript"></script>
    <link href="../../Styles/jquery-ui.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">               
                    <b>Investigation Result</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                <div>
                    <asp:RadioButtonList ID="rblLabDepartmentType" runat="server" Font-Bold="True" Font-Size="Medium" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rbllabType_SelectedIndexChanged">
                        <asp:ListItem Value="LAB">Laboratory</asp:ListItem>
                        <asp:ListItem Value="RAD">Radiology</asp:ListItem>
                        <asp:ListItem Value="ALL" Selected="True">ALL</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
                <div id="div1" style="display:none">
                    <asp:RadioButtonList ID="rbtType" runat="server" Font-Bold="True" Font-Size="Medium"
                        RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rbtType_SelectedIndexChanged">
                        <asp:ListItem Value="IPD">IPD</asp:ListItem>
                        <asp:ListItem Value="OPD">OPD</asp:ListItem>
                    </asp:RadioButtonList></div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>


                    <div id="colorindication" runat="server">
                        <table style=" width:100%">
                            <tr>
                                <td>&nbsp;<asp:Button ID="btnSN" runat="server" Width="25px" Height="25px" BackColor="LightYellow" BorderStyle="Solid" BorderColor="Black" CssClass="circle" OnClick="btnSN_Click" /></td>
                                <td><b>Test Prescribed</b></td>
                                <td><asp:Button ID="btnRN" runat="server" Width="25px" Height="25px" BackColor="#CC99FF" BorderStyle="Solid" BorderColor="" CssClass="circle" OnClick="btnRN_Click" /></td>
                                <td><b>&nbsp;Sample Collected</b></td>
                                <td><asp:Button ID="btnSC" runat="server" Width="25px" Height="25px" BackColor="#00FFFF" BorderStyle="Solid" BorderColor="" CssClass="circle" OnClick="btnSC_Click" /></td>
                                <td><b>&nbsp;Department Received</b></td>
                                <td>&nbsp;<asp:Button ID="btnNA" runat="server" Width="25px" Height="25px" BackColor="Coral" BorderStyle="Solid" BorderColor="" CssClass="circle" OnClick="btnNA_Click" /></td>
                                <td><b>Not Approved</b></td>
                                <td>&nbsp;<asp:Button ID="btnA" runat="server" Width="25px" Height="25px" BackColor="#90EE90" BorderStyle="Solid" BorderColor="" CssClass="circle" OnClick="btnA_Click" /></td>
                                <td><b>&nbsp;Approved</b></td>
                                <td>&nbsp;&nbsp;&nbsp;<asp:Button ID="btnSearch" Text="Search By Date" runat="server" OnClientClick="OpenDivSearchModel(event);"/></td>
                            </tr>
                        </table>
                    </div>
                
            </div>





            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Investigation Details
                    <asp:CheckBox ID="chkSelectAll" Checked="true" Text="De-Select All" runat="server" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                </div>

             
                    <asp:Panel ID="Panel1" runat="server" Height="264px" ScrollBars="Vertical">

                        <asp:GridView ID="GridView1" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                            OnRowCommand="GridView1_RowCommand" OnRowDataBound="GridView1_RowDataBound" >
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkSelect" runat="server" onclick="PrintOutSource(this)" ClientIDMode="Static"/>
                                        <asp:Label ID="lblReportType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ReportType") %>'
                                            Visible="False"></asp:Label>
                                        <asp:Label ID="lblLTNo" runat="server" ClientIDMode="Static" Text=' <%#Eval("LedgerTransactionNo") %>'  style="display:none;"/>
                                    </ItemTemplate>
                                    <HeaderStyle Width="25px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                              
                                 <asp:TemplateField HeaderText="Delta Check" >
                                    <ItemTemplate>
                                        <a href="javascript:void(0);"  onclick='<%#String.Format("$showDeltaModel({{type:\"{0}\",test_ID:\"{1}\"}})",Util.GetString(Eval("Type")),Util.GetString(Eval("Test_ID")))%>'  style="<%# (Util.GetString(Eval("Status"))=="NA"|| Util.GetString(Eval("Status"))=="A")?"":"display:none" %>"><img src="../../Images/view.GIF" alt="Delta Check" /></a>
                                       
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle"  Width="50px"/>
                                </asp:TemplateField>
                                 <asp:BoundField DataField="Date" HeaderText="Date">
                                    <ItemStyle Width="80px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                  <asp:BoundField DataField="BarcodeNo" HeaderText="BarcodeNo">
                                    <ItemStyle Width="40px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Department" HeaderText="Department">
                                    <ItemStyle Width="200px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Name" HeaderText="Investigations">
                                    <ItemStyle Width="340px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                            
                            <asp:BoundField DataField="IsView" HeaderText="IsView" Visible="false">
                                <ItemStyle Width="340px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:BoundField>

                             

                            
                            <asp:TemplateField HeaderText="Approve">
                                <ItemTemplate>
                                    <asp:Label ID="lblApprove" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Approved") %>' Visible="false"> </asp:Label>
                                    <asp:Label ID="lblID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>'
                                        Visible="False"> </asp:Label>
                                    <%--<asp:Label ID="lblLabInvestigationIPD_ID" runat="server" Text='<%# Eval("LabInvestigationIPD_ID") %>'
                                            Visible="False"></asp:Label>--%>
                                        <asp:Label ID="lblInvestigation_Id" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Investigation_Id") %>'
                                            Visible="False"> </asp:Label>
                                        <asp:Label ID="lblTest_ID" runat="server" Text='<%#Eval("Test_ID") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblTransactionID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"TransactionID") %>'
                                            Visible="False"></asp:Label>
                                        <asp:Label ID="lblStatus" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Status") %>'
                                            Visible="False"></asp:Label>
                                        <asp:Label ID="lblisoutsource" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"isoutsource") %>'
                                            Visible="False"></asp:Label>
                                        
                                    </ItemTemplate>
                                    <HeaderStyle Width="160px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                            <asp:TemplateField HeaderText="Ack">
                                <ItemTemplate>
                                    <input type="checkbox" class="ack_Checkbox" id="chkAck" value="<%#Eval("ID")%>" <%# Eval("IsView").ToString() == "0" ? "checked='checked'": "disabled='disabled'" %> />
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                            </asp:TemplateField>

                            <asp:BoundField DataField="Ackstring" HeaderText="Ack By">
                                <ItemStyle Width="340px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Pacs Images" Visible="false">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbPacksimage" runat="server" CausesValidation="false" CommandName="PackUrl" Visible="false"
                                            CommandArgument='<%# Eval("Test_ID") %>' ImageUrl="~/Images/view.gif" />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle"  Width="50px"/>
                                </asp:TemplateField>
                            
                                
                                <asp:TemplateField HeaderText="File" >
                                    <ItemTemplate>
                                        <a href="javascript:void(0);"  onclick="ViewDocument('<%#Eval("URL")%>')" style="<%# (Util.GetInt(Eval("CanViewFile"))==1)?"":"display:none" %>"><img src="../../Images/view.GIF" alt="View File" /></a>
                                       
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle"  Width="50px"/>
                                </asp:TemplateField>

                            
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                  
               

            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">


                <input type="button" id="btnAck" style="display: none" onclick="AckbyNurse()" value="Acknowledge" />

                <asp:Button ID="btnPrint" runat="server" Text="View"
                    OnClick="btnPrint_Click" CssClass="ItDoseButton" />
                <asp:CheckBox ID="chkHideRoom" runat="server"
                    Text="Hide Room in Report" Visible="false" />
            </div>
        </div>
        <iframe name="printIFrame" id="printIFrame" style="display: none;"></iframe>
         <div id="divDeltaCheck" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 350px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divDeltaCheck" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">View Patient Delta Check History</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-2">
                        </div>
                        <div class="col-md-10">
                            <button type="button" onclick="$DeltaCheckTabular()">Delta Check Tabular</button>
                        </div>
                        <div class="col-md-10">
                            <button type="button" onclick="$DeltaCheckGraph()">Delta Check Graph</button>
                        </div>
                        <div class="col-md-2">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>
    <div id="divSearchbyDate" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width:200px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divSearchbyDate" area-hidden="true">&times;</button>
                    <b class="modal-title">Search By Date</b>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-5">
                                    <label class="pull-left">From Date</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-7">
                                    <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" ClientIDMode="Static" TabIndex="1"></asp:TextBox>
				            		<cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">To Date</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" TabIndex="2" ToolTip="Click To Select To Date"></asp:TextBox>
						            <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSearchbyDate" Text="Search" runat="server" OnClick="btnSearchbyDate_Click" />
                    <button type="button" data-dismiss="divSearchbyDate">Close</button>
                </div>
            </div>
        </div>
    </div>

    </form>
     <script type="text/javascript">
         var $DeltaTestData = null;
         $showDeltaModel = function (DeltaTestData) {
             $DeltaTestData = null;
             $('#divDeltaCheck').showModel();
             $DeltaTestData = DeltaTestData;
         }
         $DeltaCheckTabular = function () {
             window.open('../Lab/DeltacheckNew.aspx?Type=' + $DeltaTestData.type + '&Test_ID=' + $DeltaTestData.test_ID);
         }
         $DeltaCheckGraph = function () {
             window.open('../Lab/DeltacheckGraph.aspx?Type=' + $DeltaTestData.type + '&Test_ID=' + $DeltaTestData.test_ID);
         }

         function ViewDocument(url) {
            
             if (url != '' && url != "" && url != undefined && url!=null) {
                 var url1 = "\\LABINVESTIGATION\\OutSourceLabReport\\" + url;
                 window.open("ViewFile.aspx?FileUrl=" + url1 + "&Extension=pdf");
             }
         else {
                 modelAlert("File Not Exist")
             }
         }
    </script>
    <script type="text/javascript">
        var OpenDivSearchModel = function (e) {
            e.preventDefault();
            var divSearchbyDate = $('#divSearchbyDate');
            divSearchbyDate.showModel();
        }
        var CloseDivSearchModel = function () {
            $('#divSearchbyDate').closeModel();
        }

        var PrintOutSource = function (OutSourceLabNo) {
            var count = 0;
            if (OutSourceLabNo.checked) {
                var LtNo = $(OutSourceLabNo).closest('tr').find('span[id*="lblLTNo"]').text();
                $('[id$=GridView1] tr td [id$=chkSelect]:checked').each(function () {
                    var tr = $(this).closest("tr");
                    // if (tr.find('span[id*="lblStatus"]').text() == "OS") {
                    var NewLTNo = tr.find('span[id*="lblLTNo"]').text();
                    if (LtNo != NewLTNo) {
                        count = 1;
                        tr.find('[id*=chkSelect]').prop('checked', false);
                        return;
                    }
                    //  }
                });
                if (count == 1) {
                    modelAlert('Please Select Only Same Barcode Number to print Report');
                  //  modelAlert('Please Select Only One LabNo to print OutSouce Report');
                }
            }
        }

        $(document).ready(function () {
            var field = 'IsView';
            var url = window.location.href;
            var IsView = "0";
            if (url.indexOf('?' + field + '=') != -1) {
                IsView = "1";
            }
            else if (url.indexOf('&' + field + '=') != -1) {
                IsView = "1";
                 
            }
             
            if (IsView == "1") {
                $("#btnAck").show();
            } else {
                $("#btnAck").hide();
            }

        });



    function AckbyNurse() {
        var ordId = "";
        var count = ""

        $("#GridView1 #chkAck:checked").each(function () {
            if (count == 0) {
                ordId = this.value;

            } else {
                ordId = ordId + ',' + this.value;
            }
            count = count + 1;

        });

        if (ordId!="") {
            serverCall('ViewLabReportsWard.aspx/ViewOrders', { Id: ordId }, function (response) {
                var responsedata = JSON.parse(response);
                modelAlert(responsedata.response, function () {
                    if (responsedata.status) {
                        window.location.reload();
                    }
                })

            });
        } else {
            modelAlert("Select Orders to Acknowledge.")
        }
        
    }



    </script>


</body>
</html>
