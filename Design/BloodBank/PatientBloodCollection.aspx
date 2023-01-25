<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="PatientBloodCollection.aspx.cs" Inherits="Design_BloodBank_PatientBloodCollection" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Src="~/Design/Lab/Popup.ascx" TagName="PopUp" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
    <script src="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.js"></script>
    <link href="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.css" rel="stylesheet" />
        <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>   
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Patient Blood Collection</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div id="divResult" class="POuter_Box_Inventory" style="display: none;">
            <asp:Label ID="lblNewDonationId" runat="server" Text=""></asp:Label>
            <asp:Label ID="lblSession" runat="server" Text=""></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" runat="server">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbType" runat="server" TabIndex="1" RepeatDirection="Horizontal">
                                <asp:ListItem Text="OPD" Value="OPD"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                                <asp:ListItem Text="EMG" Value="EMG"></asp:ListItem>
                                <asp:ListItem Selected="True" Value="ALL">ALL</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientId" runat="server" MaxLength="20" TabIndex="1"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNo" runat="server" MaxLength="50" TabIndex="3" ClientIDMode="Static"></asp:TextBox>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" MaxLength="50" TabIndex="3"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtdatefrom" runat="server" ClientIDMode="Static" TabIndex="4"></asp:TextBox>
                            <cc1:CalendarExtender ID="calfrom" TargetControlID="txtdatefrom" Format="dd-MMM-yyyy"
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
                            <asp:TextBox ID="txtdateTo" runat="server" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                            <cc1:CalendarExtender ID="calto" TargetControlID="txtdateTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Sample Collected
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtSampleType" runat="server" TabIndex="1" RepeatDirection="Horizontal" ClientIDMode="Static" onclick="show();">
                                   <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                  <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-9">
                    <button type="button" style="width: 25px; height: 25px; float: left; margin-left: 5px; background-color: transparent" class="circle"></button>
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Not Collected</b>
                    <button type="button" style="width: 25px; height: 25px; float: left; margin-left: 5px; background-color:  lightgreen" class="circle"></button>
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Collected</b>
                </div>
                <div class="col-md-6" style="text-align: center;">
                    <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" TabIndex="6" OnClick="btnSearch_Click" />
                </div>
                <div class="col-md-9">
                     <input type="button" id="btndoctorOrders" value="Ward Blood Coll. List" onclick="DoctorOrders()" />
                </div>
            </div>
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:GridView ID="grdPatient" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" Width="100%" OnRowDataBound="grdPatient_RowDataBound">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Type" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblType" runat="server" Text='<%# Eval("Type") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="UHID" HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID" runat="server" Text='<%# Eval("PatientID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IPD No." HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblIPDNo" runat="server" Text='<%# Util.GetString(Eval("IPDNo")).Replace("LLSHHI","").Replace("LSHHI","").Replace("LISHHI","").Replace("ISHHI","")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Patient Name" HeaderStyle-Width="140px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblPName" runat="server" Text='<%# Eval("Pname") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Age/Sex" HeaderStyle-Width="70px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblAgeSex" runat="server" Text='<%#Eval("AgeSex")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="BloodGroup" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblBloodGroup" runat="server" Text='<%# Eval("BloodGroup") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Room" HeaderStyle-Width="120px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblRoom" runat="server" Text='<%# Eval("ward") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Compenent" HeaderStyle-Width="140px" ItemStyle-CssClass="GridViewItemStyle" Visible="false"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblComponent" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reg. Date" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lbldtEntry" runat="server" Text='<%# Eval("dtEntry") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Select" HeaderStyle-Width="70px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" runat="server" />
                                <asp:Label ID="lblTransactionID" runat="server" Visible="false" Text='<%#Eval("TransactionID") %>'></asp:Label>
                                <asp:Label ID="lblLedgerTransactionNo" runat="server" Visible="false" Text='<%#Eval("LedgerTransactionNo") %>'></asp:Label>
                                <asp:Label ID="lblIsCollected" runat="server" Visible="false" Text='<%#Eval("isCollected") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </asp:Panel>
        <div class="POuter_Box_Inventory" style="text-align: center;" id="divSave" runat="server" visible="false">
            <asp:Button ID="btnSave" runat="server" Text="Collect" ClientIDMode="Static" CssClass="ItDoseButton" ToolTip="Click to Collect Sample" OnClick="btnSave_Click" OnClientClick="return validateSample(this)" />
        </div>
    </div>
    <div id="divDoctorOrders" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 50%">
                <div class="modal-header">
                    <b class="modal-title">Blood Collection Report
                    </b>

                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <input type="text" class="datepicker required" autocomplete="off" id="txtdate" />
                        </div>
                        <div class="col-md-4">
                          <label class="pull-left">From Time</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <input type="text" id="txtFromTime" class="timepicker required" autocomplete="off" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"> Ward</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlLocation">
                            </select>
                        </div>                       
                    </div>

                    <div class="row">
                         <div class="col-md-4">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-4">
                            <input type="text" class="datepicker required" autocomplete="off" id="txtToDate" />
                        </div>
                         <div class="col-md-4">
                            <label class="pull-left">To Time</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <input type="text" id="txtToTime" class="timepicker required" autocomplete="off" />
                        </div>                      
                    </div>

                    <div class="row" style="text-align: center">
                        <div class="col-md-24">
                            <input type="button" id="btnDoctorOrderReport" class="buItDoseButton" value="Report" onclick="getDoctorOrderreort();" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="divCloseoctorOrders()">Close</button>
                </div>
            </div>
        </div> 
    </div>
     <script type="text/javascript">
         function getDoctorOrderreort() {
             if ($('#txtdate').val() == '') { modelAlert("Please Select From Date"); return; }
             if ($('#txtToDate').val() == '') { modelAlert("Please Select To Date"); return; }
             if ($('#txtFromTime').val() == '') { modelAlert("Please Select From Time"); return; }
             if ($('#txtToTime').val() == '') { modelAlert("Please Select To Time"); return; }


             serverCall('PatientBloodCollection.aspx/getDoctorOrderReport', { date: $('#txtdate').val(), Todate: $('#txtToDate').val(), fromTime: $('#txtFromTime').val(), toTime: $('#txtToTime').val(), Location: $("#ddlLocation").val() }, function (response) {
                 var data = JSON.parse(response);

                 if (data.status) {
                     window.open('../../Design/common/ExportToExcel.aspx');
                 }
                 else { modelAlert(data.message); }


             });
         }

         function DoctorOrders() {
             $('#divDoctorOrders').showModel();
         }
         var divCloseoctorOrders = function () {
             $('#divDoctorOrders').closeModel();
         }
         $('.datepicker').datepicker({
             minDate: -30,
             maxDate: 0, // 1
             dateFormat: 'yy-mm-dd',
         }).datepicker("setDate", 'now');


         //var d = new Date(1980, 2, 2);
         //$('.datepicker').datepicker({
         //    changeMonth: true,
         //    changeYear: true,
         //    defaultDate: d,
         //    yearRange: '1970:1992',
         //    dateFormat: 'yy-mm-dd',
         //    monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
         //    dayNamesMin: ['Mon', 'Tue', 'Wed', 'Thu', '&#268;et', 'Pet', 'Sub']
         //});
         $('#txtFromTime').timepicker({
             timeFormat: 'h:mm p',
             interval: 1,
             minTime: '00:00',
             maxTime: '11:59pm',
             defaultTime: '00:00', //new Date(),
             startTime: '00:00',
             dynamic: false,
             dropdown: true,
             scrollbar: true
         });

         $('#txtToTime').timepicker({
             timeFormat: 'h:mm p',
             interval: 1,
             minTime: '00:00',
             maxTime: '11:59pm',
             // defaultTime: new Date(new Date().getTime() + 6 * 3600 * 1000),
             defaultTime: new Date(),
             startTime: '00:00',
             dynamic: false,
             dropdown: true,
             scrollbar: true
         });
         var $bindddlLocation = function (callback) {
             var $ddlDepartment = $('#ddlLocation');
             serverCall('PatientBloodCollection.aspx/bindLocation', {}, function (response) {
                 $ddlDepartment.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
                 callback($ddlDepartment.find('option:selected').text());
             });
         }

         $(function () {
             $('#txtdatefrom').change(function () {
                 ChkDate();
             });

             $('#txtdateTo').change(function () {
                 ChkDate();
             });
             $bindddlLocation(function () { });

         });

         function ChkDate() {
             $.ajax({
                 url: "../common/CommonService.asmx/CompareDate",
                 data: '{DateFrom:"' + $('#txtdatefrom').val() + '",DateTo:"' + $('#txtdateTo').val() + '"}',
                 type: "POST",
                 async: true,
                 dataType: "json",
                 contentType: "application/json; charset=utf-8",
                 success: function (mydata) {
                     var data = mydata.d;
                     if (data == false) {
                         $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=grdPatient.ClientID %>').hide();
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }

        function clearAllField() {
            $(':text, textarea').val('');
        }

        function validateSample(btn) {
            var counter = 0;
            $("#<%=grdPatient.ClientID%> input[id*='chkSelect']:checkbox").each(function () {
                if ($(this).is(':checked')) {
                    counter++;
                    return false;
                }
            });
            if (counter == 0) {
                modelAlert('Please Select Any Record');
                return false;
            }
        }

        function show() {
            if ($('#rdbSampleType input:checked').val() == '1') {
                $('#btnSave').hide();
            }
            else {
                $('#btnSave').show();
            }

        }
    </script>
   
</asp:Content>
