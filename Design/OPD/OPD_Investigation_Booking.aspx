<%@ Page Language="C#"  MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPD_Investigation_Booking.aspx.cs" Inherits="Design_OPD_OPD_Investigation_Booking" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            BindDoctor();
            $('.clear_input').click(function () {
                $(this).prev().val('').focus().change();
            });
        })

        function TotalSum() {
            var SurgeryCost = $("#txtSurgery").val();
            var ConsumablesCost = $("#txtConsumables").val();
            var DrugsCost = $("#txtDrugs").val();
            var AnathesiaCost = $("#txtAnathesia").val();
            var WardCost = $("#txtWard").val();
            var TotalCost = parseFloat(SurgeryCost == "" ? 0 : SurgeryCost) + parseFloat(ConsumablesCost == "" ? 0 : ConsumablesCost) + parseFloat(DrugsCost == "" ? 0 : DrugsCost) + parseFloat(AnathesiaCost == "" ? 0 : AnathesiaCost) + parseFloat(WardCost == "" ? 0 : WardCost);
            $("#txtTotalCost").val(TotalCost)
        }

        function BindDoctor() {
            var $ddlDoctor = $('.ddlDoctor');
            serverCall('../common/CommonService.asmx/bindDoctor', {}, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Doctor_ID', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
                $ddlDoctor.find('option:selected').text();
            });
        }
        $(function () {
            $('#txtfromDate').change(function () {
                ChkDate();
            });

            $('#txtToDate').change(function () {
                ChkDate();
            });
        });

        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtfromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnReport').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnReport').removeAttr('disabled');
                    }
                }
            });
        }

        var searchBooking = function () {            
            var UHID = $('#txtUHID').val();
            var fromdate = $('#ucFromDate').val();
            var todate = $('#ucToDate').val();         

            getPatientBookingDetails({ patientID: UHID, Fromdate: fromdate, Todate: todate }, function () {
            });
        }      

        var getPatientBookingDetails = function (data, callback) {
            serverCall('OPD_Investigation_Booking.aspx/GetPatientBookingDetails', data, function (response) {
                responseData = JSON.parse(response);

                console.log(responseData);
                var parseHTML = $('#template_bookingDetails').parseTemplate(responseData);
                $('.divPatientTestDetails').html(parseHTML);
                callback(responseData);
            });
        }

        var getBookingReport = function () {
            var UHID = $('#txtUHID').val();
            var fromdate = $('#ucFromDate').val();
            var todate = $('#ucToDate').val();

            getPatientBookingReport({ patientID: UHID, Fromdate: fromdate, Todate: todate }, function () {
            });
        }

        var getPatientBookingReport = function (data, callback) {
            serverCall('OPD_Investigation_Booking.aspx/GetPatientBookingReport', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open('../../Design/common/ExportToExcel.aspx');
                else
                    modelAlert('Record Not Found');
            });
        }

    </script>

     <script id="template_bookingDetails" type="text/html">
        <table  id="tableBills" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
        <thead>
        <tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col" >SNo.</th>
            <th class="GridViewHeaderStyle" >BookedFor</th>         
            <th class="GridViewHeaderStyle" >UHID</th>
            <th class="GridViewHeaderStyle" >Name</th>
            <th class="GridViewHeaderStyle" >Age</th>
            <th class="GridViewHeaderStyle" >Gender</th>
            <th class="GridViewHeaderStyle" >Address</th>
            <th class="GridViewHeaderStyle" >Mobile</th>          
            <th class="GridViewHeaderStyle" >Booked On</th>
            <th class="GridViewHeaderStyle" >BookedBy</th>  
            <th class="GridViewHeaderStyle" >Edit</th>  
            <th class="GridViewHeaderStyle" >Print</th>                                   
        </tr>
            </thead>   
            <tbody>

                <#
                     var dataLength=responseData.length;        
                     var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = responseData[j];
                #>  
                    <tr style='cursor:pointer;'>                         
       
                        <td class="GridViewLabItemStyle">  <#=j+1#>  </td> 
                        <td class="GridViewLabItemStyle"><#=objRow.BookedFor#></td>                     
                        <td class="GridViewLabItemStyle"><#=objRow.PatientID#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.PName#></td>                                  
                        <td class="GridViewLabItemStyle"><#=objRow.Age#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.Gender#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.address#></td> 
                        <td class="GridViewLabItemStyle"><#=objRow.Mobile#></td> 
                        <td class="GridViewLabItemStyle"><#=objRow.Bookedon#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.BookedBy#></td>
                         <td class="GridViewLabItemStyle hidden" id="tdData"> <#=JSON.stringify(objRow) #></td>
                        <td class="GridViewLabItemStyle textCenter"> 
                            <img alt="E" onclick="onEditBooking(this)"  class="btnOperation" style="cursor:pointer" src="../../Images/Post.gif"/>
                          </td>
                         <td class="GridViewLabItemStyle textCenter"> 
                            <img alt="E" onclick="onPrintBooking(this)"  class="btnOperation" style="cursor:pointer" src="../../Images/Print.gif"/>
                          </td>     
                     </tr>            

            <#}#>            
            </tbody>
         </table>    
    </script>

    <script type="text/javascript">
        var onEditBooking = function (el) {
            var selectedBookingDetails = JSON.parse($(el).closest('tr').find('#tdData').text());
            var divBookingEdit = $('#divBookingEdit');
            divBookingEdit.find('#spnLabBoookingEdit').text(selectedBookingDetails.BookedFor);
            bindBookingItemDetails(selectedBookingDetails.BookedFor, selectedBookingDetails.PatientID);
        }

        var bindBookingItemDetails = function (BookingDate, PatientID) {
            var divBookingEdit = $('#divBookingEdit');
            serverCall('OPD_Investigation_Booking.aspx/GetBookingDetails', { BookingDate: BookingDate, PatientID: PatientID }, function (response) {
                responseData = JSON.parse(response);
                var parseHTML = $('#template_TestBookingDetails').parseTemplate(responseData);
                divBookingEdit.find('.modal-body .row .col-md-24').html(parseHTML);
                divBookingEdit.showModel();
            });
        }

        var cancelBookingItem = function (el) {
            var data = JSON.parse($(el).closest('tr').find('.tdData').text());           
            $('#spnItemid').text(data.PatientTest_ID);
            $('#spnPatientID').text(data.PatientID);
            $('#spnPrescribeDate').text(data.PrescribeDate);
            $('#divTestwiseRemarks').showModel();
        }

        function $Saveitemesrejectremarks() {
            if ($('#txtDefaultremarks').val() == '') {
                modelAlert('Enter Remarks');
                return;
            }
            data = {               
                PatientTest_ID: $('#spnItemid').text(),
                Remarks: $('#txtDefaultremarks').val()
            }
            serverCall('OPD_Investigation_Booking.aspx/cancelBookingItem', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.message, function () {
                    $('#divTestwiseRemarks').hideModel();
                    bindBookingItemDetails($('#spnPrescribeDate').text(), $('#spnPatientID').text());
                });
            });
        }

        var onPrintBooking = function (el) {
            var selectedBookingDetails = JSON.parse($(el).closest('tr').find('#tdData').text());     
            window.open('../OPD/OPDInvBookingRequestPrintOut.aspx?BookingDate=' + selectedBookingDetails.BookedFor + '&PatientID=' + selectedBookingDetails.PatientID + '');
        }
        

    </script>

    <script id="template_TestBookingDetails"  type="text/html">
		<table  style="width: 100%; border-collapse: collapse;"     id="Table1" >       
				<thead>
					<tr>
						<th class="GridViewHeaderStyle" style="width:18px">SNo</th>
						<th class="GridViewHeaderStyle" >UHID</th>
                        <th class="GridViewHeaderStyle" >Booking Date</th>
                        <th class="GridViewHeaderStyle" >Test Name</th>                        
						<th class="GridViewHeaderStyle" >Reject</th>
						</tr>
				</thead>
				   <tbody>
			<#
			 var dataLength=responseData.length;        
			 var objRow;    
			
				for(var j=0;j<dataLength;j++)
				{
					objRow = responseData[j];
				#>          
				<tr>
					<td  class="GridViewLabItemStyle"><#= j+1 #></td>

					<td class="GridViewLabItemStyle textCenter" id="td1"> <#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle textCenter"> <#=objRow.PrescribeDate#></td>
                    <td class="GridViewLabItemStyle textCenter"> <#=objRow.TestName#></td>
                    <td class="GridViewLabItemStyle hidden" id="td2"> <#=objRow.PatientTest_ID#></td>
                    <td class="GridViewLabItemStyle hidden tdData"> <#=JSON.stringify(objRow) #></td>
                    <td class="GridViewLabItemStyle textCenter">
                        <img alt="X" onclick="cancelBookingItem(this)"  class="btnOperation" style="cursor:pointer" src="../../Images/Delete.gif"/>
                    </td>                    
				</tr>
			   <#}#>     
					</tbody>       
		 </table>
	</script>

    <script type="text/javascript">
        $(function () {
            $('input[id$=txtDig]').click(function () {
                $(this).focus().select();
            });
        });
    </script>
    <style type="text/css">
        .CssStyle1 {
            text-align: -webkit-left;
            margin-top: 2px;
            margin-bottom: 2px;
        }
        .CssStyle3 {
            margin-left: 0px;
        }
        .CssStyle4 {
            font-weight: bold;
        }
    </style>

    <div id="divBookingEdit" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divBookingEdit" aria-hidden="true">×</button>
                    <h4 class="modal-title">Edit Booking</h4>
                    <span class="spnLabBoookingEdit" style="display: none"></span>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24" style="width: 750px; max-height: 400px; overflow: auto;">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">                   
                    <button type="button" class="save" data-dismiss="divBookingEdit">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div id="divTestwiseRemarks" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 350px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divTestwiseRemarks" aria-hidden="true">×</button>
                    <h4 class="modal-title">Remarks</h4>
                    <span id="spnItemid" style="display: none"></span>
                    <span id="spnPatientID" style="display:none"></span>
                    <span id="spnPrescribeDate" style="display:none"></span>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-10">
                            <label class="pull-left">Remarks </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-14">
                            <input type="text" autocomplete="off" onlytext="30" id="txtDefaultremarks" class="form-control ItDoseTextinputText requiredField" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="$Saveitemesrejectremarks()" id="btnSavedefaultremarks" value="Save">Save</button>
                    <button type="button" data-dismiss="divTestwiseRemarks">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Future Investigations Booking for OPD Patient</b>
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
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFolderNo" runat="server" ClientIDMode="Static"></asp:TextBox>
                             <span class="clear_input">X</span>
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
                                ClientIDMode="Static" CssClass="ItDoseButton" TabIndex="3" />
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnClear" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Clear" OnClick="btnCancel_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:GridView ID="gdvList" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" Width="100%" OnRowCommand="gdvList_RowCommand">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No">
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Patient_Name">
                        <ItemTemplate>
                            <%#Eval("PName") %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Folder No">
                        <ItemTemplate>
                            <%#Eval("PatientID") %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Age">
                        <ItemTemplate>
                            <%#Eval("Age") %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Address">
                        <ItemTemplate>
                            <%#Eval("House_NO") %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="ContactNo">
                        <ItemTemplate>
                            <%#Eval("Mobile") %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Panel">
                        <ItemTemplate>
                            <%#Eval("Company_Name") %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Select">
                        <ItemTemplate>
                            <asp:ImageButton ID="imgSurgery" runat="server" ImageUrl="~/Images/Post.gif" CommandName="ShowDetails" CommandArgument='<%# Eval("PatientID") %>' />
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center" id="divDetails" runat="server" visible="false">
            <div class="Purchaseheader">
                <b>Patient Details</b>
                <br />
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-4">
                            <label>UHID</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:Label ID="lblFolderNo" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-4">
                            <label>Patient Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:Label ID="lblPatientName" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-4">
                            <label>Panel</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:Label ID="lblPanel" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label>Contact No</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:Label ID="lblContactNo" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-4">
                            <label>Age</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:Label ID="lblAge" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-4">
                            <label>Address</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:Label ID="lblAddress" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label>Centre</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:Label ID="lblCentre" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center" id="divPrescription" runat="server" visible="false">
            <div class="Purchaseheader">
                <b>Search</b>
                <br />
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Investigation Name 
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtDig" runat="server" autocomplete="off" TabIndex="6"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Qty. 
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtQty" runat="server" TextMode="Number" autocomplete="off" TabIndex="6" CssClass="required" Text="1"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Date
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox runat="server" ID="txtBookingDate" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="Calendarextender1" TargetControlID="txtBookingDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                    </div>
                    <div class="col-md-2">
                        <asp:Button ID="btnAddPrescription" Text="Add" runat="server" CssClass="ItDoseButton"
                            OnClick="btnAddPrescription_Click" />
                    </div>
                </div>
            </div>
            <div class="row">
                <asp:Panel ID="pnlHide" runat="server">
                    <div class="Purchaseheader">
                        Item Details
                    </div>
                    <div>
                        <asp:GridView ID="grvDig" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grvDig_RowCommand" Width="100%">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>

                                <asp:BoundField DataField="ID" HeaderText="ID" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ItemName" HeaderText="Item Name">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ItemId" HeaderText="Item Id" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Qty" HeaderText="Quantity">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>

                                <asp:BoundField DataField="Date" HeaderText="Date">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>

                                <asp:TemplateField HeaderText="Remove">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbRemove" runat="server" CausesValidation="false" CommandArgument="<%# Container.DataItemIndex %>"
                                            CommandName="imbRemove" ImageUrl="~/Images/Delete.gif" ToolTip="Click to Remove" />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                </asp:TemplateField>
                                <asp:TemplateField Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemId" runat="server" Text='<%# Eval("ItemId") %>'></asp:Label>
                                        <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                        <asp:Label ID="lblQty" runat="server" Text='<%# Eval("Qty") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </asp:Panel>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center" runat="server" id="DivButton" visible="false">
                <asp:Button ID="btnSave" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click" />
                <asp:Button ID="btnCancel" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Cancel" OnClick="btnCancel_Click" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <b>Search Booked Cases</b>
                <br />
            </div>                        
            <div class="row">
                <div class="col-md-2">
                    <label class="pull-left">
                        UHID
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <input type="text" id="txtUHID" />
                     <span class="clear_input">X</span>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">
                        From Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" ReadOnly="true" ClientIDMode="Static" ></asp:TextBox>
                    <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">
                        To Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="ucToDate" runat="server" ReadOnly="true"  ClientIDMode="Static" ToolTip="Click To Select To Date"></asp:TextBox>
                    <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div> 
                <div class="col-md-3" style="text-align:center">
                    <input type="button" value="Search" id="btnReportSearch" onclick="searchBooking()" />   
                </div>   
                <div class="col-md-3" style="text-align:center">
                    <input type="button" value="Report" id="btnReport" onclick="getBookingReport()" />   
                </div>              
            </div> 
        </div>
         <div class="POuter_Box_Inventory textCenter">
            <div class="Purchaseheader">
                Patient Booked Details
            </div>
            <div class="row">
                <div class="col-md-24 divPatientTestDetails" style="min-height: 230px; max-height: 230px; height: 230px; overflow: auto">
                </div>
            </div>
        </div>
    </div> 

    <cc1:AutoCompleteExtender runat="server" ID="AutoCompleteExtender1" TargetControlID="txtDig"
        FirstRowSelected="true" BehaviorID="AutoCompleteExDig" ServicePath="~/Design/CPOE/Services/AutoCompleteICD.asmx"
        ServiceMethod="GetLabPrescriptionOPD" MinimumPrefixLength="2" EnableCaching="true"
        CompletionSetCount="20" CompletionInterval="1000" CompletionListCssClass="autocomplete_completionListElement"
        CompletionListItemCssClass="autocomplete_listItem" ShowOnlyCurrentWordInCompletionListItem="true"
        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem">
        <Animations>         
                    <OnShow>
                        <Sequence>
                            <%-- Make the completion list transparent and then show it --%>
                            <OpacityAction Opacity="0" />
                            <HideAction Visible="true" />
                            
                            <%--Cache the original size of the completion list the first time
                                the animation is played and then set it to zero --%>
                            <ScriptAction Script="
                                // Cache the size and setup the initial size
                                var behavior = $find('AutoCompleteExDig');
                                if (!behavior._height) {
                                    var target = behavior.get_completionList();
                                    behavior._height = target.offsetHeight - 2;
                                    target.style.height = '0px';
                                }" />
                            
                            <%-- Expand from 0px to the appropriate size while fading in --%>
                            <Parallel Duration=".4">
                                <FadeIn />
                                <Length PropertyKey="height" StartValue="0" EndValueScript="$find('AutoCompleteExDig')._height" />
                            </Parallel>
                        </Sequence>
                    </OnShow>
                    <OnHide>
                        <%-- Collapse down to 0px and fade out --%>
                        <Parallel Duration=".4">
                            <FadeOut />
                            <Length PropertyKey="height" StartValueScript="$find('AutoCompleteExDig')._height" EndValue="0" />
                        </Parallel>
                    </OnHide>
        </Animations>
    </cc1:AutoCompleteExtender>
</asp:Content>
