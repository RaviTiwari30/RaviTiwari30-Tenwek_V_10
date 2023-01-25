<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="TransportRequisition.aspx.cs" Inherits="Design_Transport_TransportRequisition" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagPrefix="uc1" TagName="Time" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        $(document).ready(function () {
            $('.numbersOnly').keyup(function () {
                if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                    this.value = this.value.replace(/[^0-9\.]/g, '');
                }
            });

           // $("#imgMRDetail,#SpnMRNo,#txtPatientID,#div_PatientSearch").hide();
            $("#rblType input[type='radio']").change(function () {
                $("#spnErrorMsg").text('');
                $("#txtPatientID").val('');
                $("#div_PatientSearch").hide();
                $('#OldSearchOutput').hide();
                $('#tb_OPD tr').has('td').remove();
                if ($(this).val() == "1") {
                    $("#imgMRDetail,#SpnMRNo,#txtPatientID").show();
                }
                else if ($(this).val() == "2") {
                    $("#imgMRDetail,#SpnMRNo,#txtPatientID").hide();
                    $ShowNewPatModel();                  
                }
            });

            $("#imgMRDetail").click(function () {
                if ($("#txtPatientID").val() == "") {
                    $("#spnErrorMsg").text('Please Enter UHID');
                    return false;
                }

                OldPatientSearch();
            });

            $("#btnClearPopUp").bind("click", function () {
                $("#lblErrormsg").text('');
                clearPopUp();
            });

            $("#btnSave").bind("click", function () {
                $("#spnErrorMsg").text('');
                SaveTransportRequest();
            });
            $("#btnSavePopUp").bind("click", function () {
                $("#spnErrorMsg").text('');
                SaveTransportRequestPopUp();
            });

        });

        function OldPatientSearch() {
            $("#spnErrorMsg").text('');
            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/OldPatientSearch",
                data: '{PatientID:"' + $("#txtPatientID").val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    OPD = jQuery.parseJSON(response.d);
                    if (OPD != null) {
                        var output = $('#tb_OPD').parseTemplate(OPD);
                        $('#OldSearchOutput').html(output);
                        $('#OldSearchOutput').show();
                    }
                    else {
                        //DisplayMsg('MM04', 'spnErrorMsg');
                        $("#spnErrorMsg").text('Record Not Found');
                        $('#OldSearchOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }

        function ShowPatientDetail(rowID) {
            $("#spnErrorMsg").text('');
            $("#div_PatientSearch").show();
            $('#SpnPatientID').text($(rowID).closest('tr').find('#tdPatientID').text());
            $('#SpnPatientType').text($("#rblType").find("input:radio:checked").val());  //  1 for Old Patient  2 for New Patient
            $('#SpnPName').text($(rowID).closest('tr').find('#tdPName').text());
            $('#SpnAge').text($(rowID).closest('tr').find('#tdAge').text());
            $('#SpnSex').text($(rowID).closest('tr').find('#tdGender').text());
            $('#txtContactNo').val($(rowID).closest('tr').find('#tdContactNo').text());
            $('#SpnCity').text($(rowID).closest('tr').find('#tdCity').text());
            $('#txtAddress').val($(rowID).closest('tr').find('#tdAddress').text());
        }

        function clearPopUp() {
            $("#lblErrormsg,#txtPNamePopUp,#txtAgePopUp,#txtAddressPopUp,#txtCityPopUp,#txtMobilePopUp").val('');
            $("#rdoGender input[type='radio']").attr('checked', false);
        }

        function clearDetail() {
            $("#txtPatientID").val('');
            $("#txtPatientID,#SpnMRNo,#imgMRDetail").hide();
            $('#OldSearchOutput,#div_PatientSearch').hide();
            $('#tb_OPD tr').has('td').remove();
            $("#rblType input[type='radio']").attr('checked', false);
        }

        function SaveTransportRequest() {
            if ($('#txtContactNo').val().length < 10 || $('#txtContactNo').val() == '') {
                $('#txtContactNo').focus();
                alert('Enter a valid Contact No');
                return;
            }
            if ($('#txtAddress').val() == '') {
                $('#txtAddress').focus();
                alert('Enter Destination Address');
                return;
            }

            $('#btnSave').attr('disabled', true).val("Submitting...");       
            var PatientType = $("#rblType").find("input:radio:checked").val();
            $.ajax({
                url: "Services/Transport.asmx/SaveTransportRequest",
                data: JSON.stringify({
                    Type: PatientType, PatientID: $('#SpnPatientID').text(), PName: $('#SpnPName').text(), Age: $('#SpnAge').text(), Gender: $('#SpnSex').text(),
                    Mobile: $('#txtContactNo').val(), City: $('#SpnCity').text(), Address: $('#txtAddress').val(),
                    BookingDate: document.getElementById('ctl00_ContentPlaceHolder1_txtBookingDate').value,
                    BookingTime: document.getElementById('ctl00_ContentPlaceHolder1_txtBookingTime_txtTime').value
                }),
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: "120000",
                dataType: "json",
                success: function (result) {
                    OutPut = result.d;
                    if (result.d == "1") {
                        $("#spnErrorMsg").text('Record Saved Successfully');
                        alert('Record Saved Successfully ');
                        $('#btnSave').attr('disabled', false).val("Save");
                        clearDetail();                      
                    }
                    else {
                        $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                        $('#btnSave').attr('disabled', true).val("Save");
                    }
                },
                error: function (xhr, status) {
                    $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                    $('#btnSave').attr('disabled', true).val("Save");
                }
            });
        }

        function SaveTransportRequestPopUp() {
            if ($('#txtPNamePopUp').val() == '') {
                $('#txtPNamePopUp').focus();
                alert('Enter Patient Name');
                return;
            }
            if ($('#txtAgePopUp').val() == '') {
                $('#txtAgePopUp').focus();
                alert('Enter Patient Age');
                return;

            }
            if ($('#txtAddressPopUp').val() == '') {
                $('#txtAddressPopUp').focus();
                alert('Enter Destination Address');
                return;

            }
            if ($('#txtCityPopUp').val() == '') {
                $('#txtCityPopUp').focus();
                alert('Enter Destination City');
                return;
            }
            if ($('#txtMobilePopUp').val().length < 10 || $('#txtMobilePopUp').val() == '') {
                $('#txtMobilePopUp').focus();
                alert('Enter a valid Contact Number');
                return;
            }

            $('#btnSavePopUp').attr('disabled', true).val("Submitting...");
            var PatientType = $("#rblType").find("input:radio:checked").val();
            $.ajax({
                url: "Services/Transport.asmx/SaveTransportRequestPopUp",
                data: JSON.stringify({
                    Type: PatientType, PName: $('#txtPNamePopUp').val(), Gender: $("#rdoGender").find("input:radio:checked").val(),
                    Age: $('#txtAgePopUp').val() + ' ' + $('#ddlAge').val(), Address: $('#txtAddressPopUp').val(), City: $('#txtCityPopUp').val(), Mobile: $('#txtMobilePopUp').val(),
                    BookingDate: document.getElementById('ctl00_ContentPlaceHolder1_txtBookingDatePopUp').value,
                    BookingTime: document.getElementById('ctl00_ContentPlaceHolder1_txtBookingTimePopUp_txtTime').value
                }),
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: "120000",
                dataType: "json",
                success: function (result) {
                    OutPut = result.d;
                    if (result.d == "1") {
                        $("#spnErrorMsg").text('Record Saved Successfully');
                        alert('Record Saved Successfully ');
                        $('#btnSavePopUp').attr('disabled', true).val("Save");
                        clearPopUp();
                        $("#rblType input[type='radio']").attr('checked', false);
                        $('#divNewPatModel').closeModel();
                    }
                    else {
                        $("#SpnErrorPopUp").text('Error occurred, Please contact administrator');
                        $('#btnSavePopUp').attr('disabled', true).val("Save");
                    }
                },
                error: function (xhr, status) {
                    $("#SpnErrorPopUp").text('Error occurred, Please contact administrator');
                    $('#btnSavePopUp').attr('disabled', true).val("Save");
                }
            });
        }

    </script>

    <script type="text/javascript">
        $(function () {          
            AvailableVehicleList();
        });

        $ShowVehicleStatusModel = function () {
            $('#divVehicleStatusModel').showModel();
        }

        $ShowNewPatModel = function () {
            $('#btnSavePopUp').attr('disabled', false).val("Save");
            $('#divNewPatModel').showModel();
        }

        function AvailableVehicleList() {
            $("#vehicle_div").empty();
            var Requests = Array();
            var Status = Array();

            $.ajax({

                url: "Services/Transport.asmx/AvailableVehicleList",
                data: '{}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    if (mydata.d != null && mydata.d != "0") {
                        VehicleStatus = $.parseJSON(mydata.d);
                        if (VehicleStatus.length > 0) {
                            var HtmlOutput = $("#statusScript").parseTemplate(VehicleStatus);
                            $("#vehicle_div").html(HtmlOutput);
                            $("#vehicle_div").show();
                            Status = VehicleStatus;
                        }
                        else {
                            $("#vehicle_div").hide();
                        }
                    }
                    else {
                        $("#vehicle_div").empty();
                        $("#vehicle_div").hide();
                    }
                },
                error: function (xhr, status) {
                    $("#vehicle_div").empty();
                    $("#vehicle_div").hide();
                }
            });
        }


    </script>
     <script type="text/html" id="statusScript">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;margin:0 auto;">
		    <tr>            
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">VehicleNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">VehicleName</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">RcNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Model</th>			    	                				                                        	            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">VehicleType</th>	
		    </tr>
		    <#       
		    var dataLength=VehicleStatus.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;               
		    for(var j=0;j<dataLength;j++)
		    {
                objRow=VehicleStatus[j];
                                
		    #>
				    <tr>                                          
                        <td class="GridViewLabItemStyle" style="width:50px;text-align:center;" ><#=(j+1)#></td>
					    <td class="GridViewLabItemStyle" style="width:100px;text-align:left;" ><#=objRow.VehicleNo#></td>
                        <td class="GridViewLabItemStyle" style="width:200px;text-align:left; "><#=objRow.VehicleName#></td>    
					    <td class="GridViewLabItemStyle" style="width:100px;text-align:left; "><#=objRow.RcNo#></td> 
                        <td class="GridViewLabItemStyle" style="width:70px;text-align:left; "><#=objRow.Model#></td>  
                        <td class="GridViewLabItemStyle" style="width:90px;text-align:left; "><#=objRow.VehicleType#></td>                       
                    </tr>            
                
		    <#}        
		    #>                   
	    </table>    
    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Patient Requisition</b><br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            <br />
           
        </div>


        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
       <div class="POuter_Box_Inventory" id="divRequestDetail" style="text-align: center;">
            <div class="Purchaseheader">
               Patient Requisition
            </div>
            <div>
                <table style="width: 100%">

                    <tr>
                        <td style="width: 12%; text-align: right;">Patient Type :&nbsp;</td>
                        <td style="width: 25%; text-align: left;">
                             <asp:RadioButtonList ID="rblType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                                <asp:ListItem Text="Hospital Patient" Value="1" Selected="True" />
                                <asp:ListItem Text="New Patient" Value="2"  style="display:none"/>
                        </asp:RadioButtonList>                          
                        </td>
                        <td style="width: 10%; text-align: right;"><span id="SpnMRNo" >UHID :</span>   &nbsp;</td>
                        <td style="width: 15%; text-align: left;">
                              <input type="text" id="txtPatientID" style="width: 130px;" maxlength="20" title="Enter UHID"  class="requiredField"   />   
                            <img id="imgMRDetail" alt="" src="../../Images/view.gif" style="cursor:pointer"  />                      
                        </td>
                        <td style="width: 23%; text-align: right;">List of Available Vehicle :&nbsp;</td>
                        <td style="width: 5%; text-align: left;">
                         

                              <img alt="" src="../../Images/view.gif" style="cursor:pointer"  onclick="$ShowVehicleStatusModel()" />  
                        </td>
                    </tr>
                    </table>                                                                                                        
            </div>
          
        </div>
         
        <div class="POuter_Box_Inventory">
    <div class="Purchaseheader" >
        Search Result</div>
     
                         <div id="OldSearchOutput" style="max-height: 600px; overflow-x: auto;">
                        </div>
           
           
             <div  style="text-align: center;display:none;" id="div_PatientSearch">            
         

                 <div class="Purchaseheader">
                    Patient Detail
                    </div>

                 <div>

               <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            <span id="Span2" class="pull-left">Patient Name</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">
                              <span id="SpnPatientID" style="display:none;"></span> 
                            <span id="SpnPatientType" style="display:none;"></span>  
                            <span id="SpnPName" ></span> 
                        </div>                        
                        <div class="col-md-3">                          
                             <span id="Span3" class="pull-left">Age/Sex</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left"> 
                             <span id="SpnAge" ></span>/<span id="SpnSex" ></span>   
                        </div>
                        <div class="col-md-3">                           
                            <span id="Span4" class="pull-left">Contact No</span>                       
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">                            
                             <input type="text" id="txtContactNo" style="width:120px;" maxlength="10" title="Enter Mobile No"  class="numbersOnly requiredField"   />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            <span id="Span5" class="pull-left">City</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">
                               <span id="SpnCity"></span>
                        </div>                        
                        <div class="col-md-3">                          
                             <span id="Span9" class="pull-left">Address</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13"  style="text-align:left"> 
                               <input type="text" id="txtAddress" style="width:300px;" maxlength="20" title="Enter Address" class="requiredField" />  
                        </div>
                        
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

         <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            <span id="Span6" class="pull-left">Booking Date</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21"  style="text-align:left">
                             <asp:TextBox ID="txtBookingDate" runat="server" ToolTip="Click To Select Booking Date" CssClass="ItDoseTextinputText" Width="130px" />
                                   <uc1:Time ID="txtBookingTime" runat="server" />
                            <cc1:CalendarExtender ID="calBookingDate" runat="server" TargetControlID="txtBookingDate" Format="dd-MMM-yyyy" />

                        </div>
                        
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
                            
        <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-24">
                            <input type="button" id="btnSave" value="Save" class="ItDoseButton" />
                        </div>
                        
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
                   
        </div>

             

           </div>         
               
             
                
<div id="divNewPatModel"   class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color:white;width:1100px;height:auto;">
                <div class="modal-header">
                    <h4 class="modal-title">Enter Detail For Non Registered Patient</h4>
                    <b><span id="SpnErrorPopUp" class="ItDoseLblError"></span></b>  
                </div>
                <div class="modal-body">
                     <div class="row">
                         <div class="col-md-24">
                             
             <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            <span id="SpnPatientNamePopUp" class="pull-left">Patient Name</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">
                            <input type="text" id="txtPNamePopUp" style="width:150px;" maxlength="20" title="Enter Patient Name" class="requiredField"  />
                        </div>                        
                        <div class="col-md-3">                          
                             <span id="SpnGenderPopUp" class="pull-left">Gender</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="text-align:left"> 
                            <asp:RadioButtonList ID="rdoGender" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                                    <asp:ListItem Text="Male" Value="Male" Selected="True" />
                                    <asp:ListItem Text="Female" Value="Female" />
                            </asp:RadioButtonList> 
                        </div>
                        <div class="col-md-3">                           
                            <span id="SpnAgePopUp" class="pull-left">Age</span>                       
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">                            
                            <input type="text" id="txtAgePopUp" style="width:60px;" maxlength="20" title="Enter Patient Age"  class="numbersOnly requiredField"  />
                            <select id="ddlAge" style=" width:60px;">
                                <option value="YRS">YRS</option>
                                <option value="MONTH(S)">MONTH(S)</option>
                                <option value="DAYS(S)">DAYS(S)</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>


            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                     
                        <div class="col-md-3">                         
                            <span id="SpnAddressPopUp" class="pull-left">Address</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">
                            <input type="text" id="txtAddressPopUp" style="width:150px;" maxlength="20" title="Enter Address" class="requiredField"  />
                        </div>
                        
                        <div class="col-md-3">                          
                             <span id="SpnCityPopUp" class="pull-left">City</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left"> 
                            <input type="text" id="txtCityPopUp" style="width:150px;" maxlength="20" title="Enter City"  class="requiredField" />
                        </div>


                        <div class="col-md-3">                           
                            <span id="SpnMobilePopUp" class="pull-left">Mobile</span>                       
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">                            
                            <input type="text" id="txtMobilePopUp" style="width:120px;" maxlength="10" title="Enter Mobile No"  class="numbersOnly requiredField"  />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>


              <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                     
                        <div class="col-md-3">                         
                            <span id="SpnBookingDate" class="pull-left">Booking Date</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21" style="text-align:left;">
                           <asp:TextBox ID="txtBookingDatePopUp" runat="server" ToolTip="Click To Select Booking Date" CssClass="ItDoseTextinputText" Width="130px"  />
                                   <uc1:Time ID="txtBookingTimePopUp" runat="server" />
                            <cc1:CalendarExtender ID="calBookingDatePopUp" runat="server" TargetControlID="txtBookingDatePopUp" Format="dd-MMM-yyyy" />
                        </div>                       
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

    <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                     
                        <div class="col-md-24">                         
                             <input type="button" id="btnSavePopUp" value="Save" class="ItDoseButton" />&nbsp
                    <input type="button" id="btnClearPopUp" value="Clear" class="ItDoseButton" />
                        </div>
                                           
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>



                          </div>
                       
                      </div>
                </div>
                  <div class="modal-footer">
                       
                         <button type="button"  data-dismiss="divNewPatModel" >Close</button>
                </div>
            </div>
        </div>
    </div>
               
                     
<div id="divVehicleStatusModel"   class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color:white;width:750px;height:auto;">
                <div class="modal-header">
                    <h4 class="modal-title">Vehicle Status</h4>
                     <span id="Span1" class="ItDoseLblError"></span>
                </div>
                <div class="modal-body">
                     <div class="row">
                         <div class="col-md-20">
                                <div id="vehicle_div" style="margin: 0 auto;width:720px; height:180px; overflow:scroll;">
                            </div>
                          </div>
                       
                      </div>
                </div>
                  <div class="modal-footer">
                       
                         <button type="button"  data-dismiss="divVehicleStatusModel" >Close</button>
                </div>
            </div>
        </div>
    </div>



</div>     
            
               
    </div>

     <script id="tb_OPD" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" 
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px; text-align:left;">Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Age</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Sex</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px; text-align:left;">Contact No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px; text-align:left;">City</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px; text-align:left;">Address</th>
            
          
             <th class="GridViewHeaderStyle" scope="col" style="width:20px;"></th>
		</tr>
        <#       
        var dataLength=OPD.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = OPD[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                          
    
                    
                        <td class="GridViewLabItemStyle"  style="width:100px;" id="tdPatientID"><#=objRow.PatientID#></td>
                        <td class="GridViewLabItemStyle"  style="width:200px; text-align:left;" id="tdPName"><#=objRow.PName#></td>
                        <td class="GridViewLabItemStyle"  style="width:80px;" id="tdAge"><#=objRow.Age#></td>
                        <td class="GridViewLabItemStyle"  style="width:50px;" id="tdGender"><#=objRow.Gender#></td>
                        <td class="GridViewLabItemStyle"  style="width:80px; text-align:left;" id="tdContactNo"><#=objRow.ContactNo#></td>
                        <td class="GridViewLabItemStyle"  style="width:100px; text-align:left;" id="tdCity"><#=objRow.city#></td>
                        <td class="GridViewLabItemStyle"  style="width:200px; text-align:left;" id="tdAddress"><#=objRow.Address#></td>
                       
                        <td class="GridViewLabItemStyle"  style="width:20px;">  
                            <input type="button"  value="Edit" class="ItDoseButton" onclick="ShowPatientDetail(this)" />
                        </td>
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>
     
</asp:Content>
