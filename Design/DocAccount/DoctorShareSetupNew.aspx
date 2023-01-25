<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DoctorShareSetupNew.aspx.cs" Inherits="Design_DocAccount_DoctorShareSetupNew" %>

<%@ Register TagPrefix="CE" Namespace="CuteEditor" Assembly="CuteEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
      <style  type="text/css">
        .selectedRow {
            background-color: aqua !important;
        }
    </style>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center">
                <b>Doctor Share Setup</b>&nbsp;<br />
                <label id="lblMsg" class="ItDoseLblError"></label>
            </div>
        </div>
        <div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" >
                    Filter Criteria
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">

                             <div class="col-md-3">
                                <label class="pull-left">Service Type</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlServiceType" onchange="clearControls(function () { });" tabindex="1" class="requiredField">
                                    <option value="1" selected="selected">Service Setup</option>
                                    <option value="2">Package Setup</option>
                                    <option value="3">Surgery Setup</option>
                                  <option value="4">Doctor Configuration Setup</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">Centre</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlCentre" tabindex="2" onchange="onCentreChange(function(){});" class="requiredField"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Doctor</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlDoctor" tabindex="3" onchange="clearControls(function () { });" class="requiredField"></select>
                            </div>
                            </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Share Type</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlType" onchange="onTypeChange(function(){});" tabindex="4" class="requiredField">
                                    <option value="2" selected="selected">Panel Group</option>
                                    <option value="3">Panel</option>
                                </select>
                            </div>
                             <div class="col-md-3">
                                <label class="pull-left lblPanel">Panel Group</label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-5">
                                <select id="ddlPanel" tabindex="5" onchange="clearControls(function () { });" class="requiredField"></select>
                            </div>
                            <div class="col-md-3">
                            </div>
                            <div class="col-md-5">
                                <input type="button" id="btnSearch" class="ItDoseButton" tabindex="6" value="Search" onclick="bindDoctorShare(function () { });" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory isSave" style="display:none;">
                <div class="Purchaseheader dvServiceType" >
                    Doctor Share Setting
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div id="divServiceTypeData" style="max-height: 425px;overflow:auto;">
                        </div>

                        <div id="divExcludePackage" style="max-height: 425px;overflow:auto;">
                            <div class="row">
                                 <div class="col-md-3">
                                    <label class="pull-left">Package</label>
                                    <b class="pull-right">:</b>
                                 </div>
                                 <div class="col-md-5">
                                    <select id="ddlPackage" tabindex="7" onchange="bindDoctorShare(function () { });" ></select>
                                </div> 
                                <div class="col-md-16">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-8">
                                   <div id="divExcludePackageCategory" style="max-height: 425px;overflow:auto;">
                                   </div>
                                </div>
                                 <div class="col-md-8">
                                   <div id="divExcludePackageSubCategory" style="max-height: 425px;overflow:auto;">
                                   </div>
                                </div> 
                                <div class="col-md-8">
                                   <div id="divExcludePackageItem" style="max-height: 425px;overflow:auto;">
                                   </div>
                                </div>
                            </div>
                        </div>

                        <div id="divDoctorConfigurationData" style="max-height: 425px;overflow:auto;">
                            <div class="row">
                                <div class="col-md-16">
                                   <div id="divDoctorSettingData" style="max-height: 425px;overflow:auto;">

                                       <div class="row">
                                           <div class="col-md-6">
                                                <label class="pull-left">Share Category</label>
                                                <b class="pull-right">:</b>
                                            </div>
                                            <div class="col-md-6">
                                                <select id="ddlShareCategory" onchange="bindDoctorSalary(this);" >
                                                    <option value="1" selected="selected">Share Basis</option>
                                                    <option value="2">Salary Basis</option>
                                                </select>
                                            </div>
                                             <div class="col-md-8">
                                                <label class="pull-left">Salary</label>
                                                <b class="pull-right">:</b>
                                            </div>
                                            <div class="col-md-4">
                                                <input type="text" id="txtSalary" onlynumber='14'  decimalplace='2'  max-value='10000000'  class='ItDoseTextinputNum' />
                                            </div>
                                       </div>
                                       <div class="row">
                                           <div class="col-md-6">
                                                <label class="pull-left">Calculation Type</label>
                                                <b class="pull-right">:</b>
                                            </div>
                                            <div class="col-md-6">
                                                <select id="ddlShareCalculationType">
                                                    <option value="1" selected="selected">Revenue Basis</option>
                                                    <option value="2">Collection Basis</option>
                                                </select>
                                            </div>
                                             <div class="col-md-8">
                                                <label class="pull-left">WriteOff & Deduct Apply</label>
                                                <b class="pull-right">:</b>
                                            </div>
                                            <div class="col-md-4">
                                                <select id="ddlWriteOffAndDeductApply" >
                                                    <option value="1" selected="selected">Yes</option>
                                                    <option value="0">No</option>
                                                </select>
                                            </div>
                                       </div>
                                       <div class="row">
                                           <div class="col-md-24">
                                               <br />
                                               <div id="divUnitDoctorShareSetup" style="max-height: 340px;overflow:auto;"></div>
                                           </div>
                                       </div>
                                   </div>
                                </div> 
                                <div class="col-md-8">
                                   <div id="divDiscBearedByData" style="max-height: 425px;overflow:auto;">
                                   </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory isSave" style="text-align: center; display:none;" >
               <input type="button" style=" width: 100px; margin-top: 3px" id="btnSave" class="ItDoseButton" value="Save" onclick="saveDoctorShare(this,1);" />
            </div> 
        </div>
    </div>

    
     <div id="divSubCategoryDetails" class="modal fade"  >
		<div class="modal-dialog">
			<div class="modal-content" style="min-width: 650px; max-width:1300px;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divSubCategoryDetails" aria-hidden="true">×</button>
					<b class="modal-title">Sub-Category Wise Share (<span id="spnSubCategoryHeader"></span>)
                         
					</b>
				</div>
				<div class="modal-body">
                    <div class="row">
                        <div class="col-md-2">
							<label class="pull-left">
								Search
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
                            <div class="chosen-container-single">
							 <div style="padding:0px;z-index:0" class="chosen-search">
								 <input type="text" style="border-radius: 5px;height:22px;" class="chosen-search-input" onkeyup="GridSearch(1)"  placeholder="Search Sub-Category" id="txtSubCategorySearch" />
							</div>
						  </div>
						</div>
                        <div class="col-md-17">
                        </div>
					</div>

					<div class="row">
						<div class="col-md-24">
                            <div id="divSubCategoryWiseData" style="max-height: 425px;overflow:auto;"></div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" onclick="saveDoctorShare(this,2);" class="save">Save</button>
					<button type="button" data-dismiss="divSubCategoryDetails">Close</button>
				</div>
			</div>
		</div>
	</div>


     <div id="divItemDetails" class="modal fade"  >
		<div class="modal-dialog">
			<div class="modal-content" style="min-width: 650px; max-width:1300px;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divItemDetails" aria-hidden="true">×</button>
					<b class="modal-title">Item Wise Share (<span id="spnItemHeader"></span>)
                         
					</b>
				</div>
				<div class="modal-body">
                     <div class="row">
                        <div class="col-md-2">
							<label class="pull-left">
								Search
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
                            <div class="chosen-container-single">
							 <div style="padding:0px;z-index:0" class="chosen-search">
								 <input type="text" style="border-radius: 5px;height:22px;" class="chosen-search-input" onkeyup="GridSearch(2)"  placeholder="Search Item" id="txtItemSearch" />
							</div>
						  </div>
						</div>
                        <div class="col-md-17">
                        </div>
					</div>
					<div class="row">
						<div class="col-md-24">
                            <div id="divItemWiseData" style="max-height: 425px;overflow:auto;"></div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" onclick="saveDoctorShare(this,3);" class="save">Save</button>
					<button type="button" data-dismiss="divItemDetails">Close</button>
				</div>
			</div>
		</div>
	</div>

    
    <div id="divRecalculateModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 300px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divRecalculateModel" aria-hidden="true">&times;</button>
                    <b class="modal-title">Re-Calculate Setup ( <span id="spnReCalculateDoctorName" class="patientInfo"></span> )</b>
                    <span id="spnReCalculateDoctorID" style="display:none;"></span>
                     <span id="spnReCalculateCentreID" style="display:none;"></span>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24">
                            <div class="row">
                                <div class="col-md-14">
                                    <label class="pull-left" style="font-weight: bold">
                                       Apply Current Doctor Share From Month
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-4">
                                    <input type="text" id="txtApplyMonth" maxlength="5" class="requiredField" placeholder="mm/YY" onkeypress="return validateApplyMonth(this,event,1);" onkeyup="return validateApplyMonth(this,event,2);" title="Enter in mm/YY Format" />
                                </div>
                               <div class="col-md-6">
                                    <button type="button" onclick="reCalculateDoctorShare(this)" class="save" >Re-Calculate</button>
                               </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="font-weight:bold;color:red; text-align:left;">
                  Note : 1. It will take few time for applying re-calculating process. <br /> 
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. Don't refresh the screen untill it will not apply successfully.
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        //*****Global Variables*******
        var DoctorSharePageChache = [];
        var CategoryWiseReferralWise = [];
        var SubCategoryWiseReferralWise = [];
        var ItemWiseReferralWise = [];
        $(function () {
            CreateDoctorShareTempTable(function () {
                configureDoctorSharePageChache(function () {
                    $bindCentre(function () {
                        $bindPanel(function () { });
                        $bindDoctor(function () { });
                        $bindIPDPackage(function () { });
                    });
                });
            });
        });


        function GridSearch(type) {
            var input, filter, table, tr, td, i;

            if (type == 1) {
                input = document.getElementById('txtSubCategorySearch');
                filter = input.value.toUpperCase();
                table = document.getElementById("tblSubCategoryWise");
                tr = table.getElementsByTagName("tr");

                if (filter.length > 0) {
                    $('#chkSubCatAll').attr('disabled', 'disabled');
                    tr[2].style.display = "none";
                }
                else {
                    $('#chkSubCatAll').removeAttr('disabled');
                    tr[2].style.display = "";
                }

                for (i = 3; i < tr.length; i++) {
                    var tdData = JSON.parse($(tr[i]).find('#tdSubCatRowData').text());
                    if (tdData.CategoryName.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
            else {

                input = document.getElementById('txtItemSearch');
                filter = input.value.toUpperCase();
                table = document.getElementById("tblItemWise");
                tr = table.getElementsByTagName("tr");

                if (filter.length > 0) {
                    $('#chkItemAll').attr('disabled', 'disabled');
                    tr[2].style.display = "none";
                }
                else {
                    $('#chkItemAll').removeAttr('disabled');
                    tr[2].style.display = "";
                }

                for (i = 3; i < tr.length; i++) {
                    var tdData = JSON.parse($(tr[i]).find('#tdItemRowData').text());
                    if (tdData.CategoryName.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }

        function validateApplyMonth(sender, e,type) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                           ((e.keyCode) ? e.keyCode :
                           ((e.which) ? e.which : 0));


                if (type == 1) {
                    if (charCode != 8 && (charCode < 48 || charCode > 57))
                        return false;

                }

                if (strVal.charAt(0) == '/')
                    $(sender).val('01/');
                if (strVal.charAt(1) == '/')
                    $(sender).val('0' + strVal);
                if (strVal.charAt(2) == '/') {
                    if (parseFloat(strVal.split('/')[0]) > 12 || parseFloat(strVal.split('/')[0]) < 1) {
                        modelAlert('Invalid Month');
                        $(sender).val('').focus();
                    }
                }
                if (strVal.length == 2 && charCode != 8 && strVal.charAt(1) != '/')
                    $(sender).val(strVal + '/');

                if (strVal.charAt(3) == '/' && charCode != 8)
                    $(sender).val(strVal.substring(0, 3));

                if (strVal.length == 5 && charCode != 8) {
                    if (parseFloat(strVal.split('/')[1]) > parseFloat($.datepicker.formatDate('y', new Date()))) {
                        modelAlert('Date Cannot be Greater than Current Date');
                        $(sender).val('').focus();
                    }
                    else {
                        if ((parseFloat(strVal.split('/')[1]) == parseFloat($.datepicker.formatDate('y', new Date()))) && (parseFloat(strVal.split('/')[0]) > parseFloat($.datepicker.formatDate('mm', new Date(new Date().getTime() + 24 * 60 * 60 * 1000))))) {
                            modelAlert('Date Cannot be Greater than Current Date');
                            $(sender).val('').focus();
                        }

                    }
                }

            }
        }

        var CreateDoctorShareTempTable = function (callback) {
            serverCall('DoctorShareSetupNew.aspx/CreateDoctorShareTempTable', {}, function (response) {
                var responseData = response == "1" ? true : false;
                callback(responseData);
            });
        }
        var configureDoctorSharePageChache = function (callback) {
            serverCall('DoctorShareSetupNew.aspx/bindDoctorShareControls', {}, function (response) {
                var responseData = JSON.parse(response);
                DoctorSharePageChache = responseData; //assign to global variables
                callback();
            });
        }

        var $bindCentre = function (callback) {
            var responseData = DoctorSharePageChache.filter(function (i) { return i.TypeID == 5 });
            $Centre = $('#ddlCentre');
            $Centre.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: '<%=Util.GetString(ViewState["CurrentCentreID"])%>' });
            callback($Centre.find('option:selected').text());
        }
        var $bindDoctor = function (callback) {
            var responseData = DoctorSharePageChache.filter(function (i) { return i.TypeID == 1 && i.CentreID == Number($('#ddlCentre').val()) });
            var $ddlDoctor = $('#ddlDoctor');
            $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: "Select" });
            callback($ddlDoctor.find('option:selected').text());
        }
        var $bindIPDPackage = function (callback) {
            var responseData = DoctorSharePageChache.filter(function (i) { return i.TypeID == 7 });
            var $ddlPackage = $('#ddlPackage');
            $ddlPackage.bindDropDown({ defaultValue: 'All', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: "Select" });
            callback($ddlPackage.find('option:selected').text());
        }

        


        var $bindPanel = function (callback) {
            $('.lblPanel').text($('#ddlType option:selected').text());
            var centreId = Number($('#ddlType').val()) == 2 ? 0 : Number($('#ddlCentre').val());
            var responseData = DoctorSharePageChache.filter(function (i) { return i.TypeID == Number($('#ddlType').val()) && i.CentreID == centreId });
            var $ddlPanel = $('#ddlPanel');
            $ddlPanel.bindDropDown({ defaultValue: 'All', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: "Select" });
            callback($ddlPanel.find('option:selected').text());
        }

        var onCentreChange = function () {
            $bindPanel(function () { });
            $bindDoctor(function () { });
            clearControls(function () { });
        }
        var onTypeChange = function () {
            $bindPanel(function () {
                clearControls(function () {
                });
            });
        }

        var bindDoctorShare = function () {
            bindDoctorShareCentreWiseDoctorWise(1,0,0,function () {
                bindCategoryWiseReferralWiseDoctorShareGrid(function () {
                });
            });
        }

        var bindDoctorSalary = function (ctrl) {
            if ($(ctrl).val() == '1')
                $('#txtSalary').val('0').attr('disabled', true).removeClass('requiredField');
            else
                $('#txtSalary').val($('#txtSalary').attr('Salary')).removeAttr('disabled').addClass('requiredField');
        }
        var clearControls = function () {
            $('#divExcludePackage').hide();
            $('#divServiceTypeData,#divExcludePackageCategory,#divExcludePackageSubCategory,#divExcludePackageItem,#divDiscBearedByData,#divUnitDoctorShareSetup').html('');
            $('.isSave').hide();

            $('#divDoctorConfigurationData').hide();

            $('.dvServiceType').text($('#ddlServiceType option:selected').text());

            if (Number($('#ddlServiceType').val()) == 2) {
                $('#ddlDoctor').attr('disabled', 'disabled');
                $('#ddlDoctor').val("0");
            }
            else {
                $('#ddlDoctor').removeAttr('disabled');
            }
            $('#ddlDoctor').chosen("destroy").chosen({ width: '247px' });


            if (Number($('#ddlServiceType').val()) == 4) {
                $('#ddlType,#ddlPanel').attr('disabled', 'disabled');
                $('#ddlPanel').val("0");
            }
            else
                $('#ddlType,#ddlPanel').removeAttr('disabled');

            $('#ddlPanel').chosen("destroy").chosen({ width: '247px' });

        }

        var bindDoctorShareCentreWiseDoctorWise = function (GridType,CategoryID,SubCategoryID, callback) {
            $('#lblMsg').text('');

            if (Number($('#ddlCentre').val()) == 0 && Number($('#ddlServiceType').val()) != 4) {
                $('#lblMsg').text('Please Select Doctor');
                return;
            }

            if (Number($('#ddlDoctor').val()) == 0 && Number($('#ddlServiceType').val()) !=2) {
                $('#lblMsg').text('Please Select Doctor');
                return;
            }
            data = {
                gridType: GridType,
                centreID: Number($('#ddlCentre').val()),
                doctorID: Number($('#ddlDoctor').val()),
                shareType: Number($('#ddlType').val())==2 ? 1:2,
                panelGroupID: Number($('#ddlType').val()) == 3 ? 0 : Number($('#ddlPanel').val()),
                panelID: Number($('#ddlType').val()) == 2 ? 0 : Number($('#ddlPanel').val()),
                serviceType: Number($('#ddlServiceType').val()),
                packageID: Number($('#ddlPackage').val()),
                categoryID: CategoryID,
                subCategoryID: SubCategoryID
            }
            serverCall('DoctorShareSetupNew.aspx/bindDoctorShareCentreWiseDoctorWise', data, function (response) {
                var responseData = JSON.parse(response);
                if(GridType ==1) {

                    CategoryWiseReferralWise = responseData; //assign to global variables
                }
                else if (GridType == 2)
                    SubCategoryWiseReferralWise = responseData; //assign to global variables
                else
                    ItemWiseReferralWise = responseData; //assign to global variables
                callback();
            });
        }


      var bindUnitDoctorSetup = function (callback) {
            data = {
                centreID: Number($('#ddlCentre').val()),
                doctorID: Number($('#ddlDoctor').val()),
            }
            serverCall('DoctorShareSetupNew.aspx/bindUnitDoctorShareDetails', data, function (response) {
                UnitDoctorSetup = JSON.parse(response);
                var $template = $('#templateUnitDoctorSetup').parseTemplate(UnitDoctorSetup);
                $('#divUnitDoctorShareSetup').html($template).customFixedHeader();
                MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                callback(true);
            });
        }
        var bindCategoryWiseReferralWiseDoctorShareGrid = function () {

            clearControls(function () { });

            if (CategoryWiseReferralWise.length > 0) {

                if (CategoryWiseReferralWise[0].ServiceType == 2) {
                    $('#divExcludePackage').show();
                    ExcludeCategories = CategoryWiseReferralWise;
                    var $template = $('#templateExcludeCategory').parseTemplate(ExcludeCategories);
                    $('#divExcludePackageCategory').html($template).customFixedHeader();

                    MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                }
                else if (CategoryWiseReferralWise[0].ServiceType == 4) {
                   
                    DoctorWiseConfiguration = CategoryWiseReferralWise;

                    $('#ddlShareCategory').val(DoctorWiseConfiguration[0].ShareCategory);
                    $('#ddlShareCalculationType').val(DoctorWiseConfiguration[0].ShareCalculationType);
                    $('#txtSalary').val(DoctorWiseConfiguration[0].Salary).attr('Salary', DoctorWiseConfiguration[0].Salary);

                    if (Number(DoctorWiseConfiguration[0].ShareCategory) == 1)
                        $('#txtSalary').attr('disabled', 'disabled').removeClass('requiredField');
                    else
                        $('#txtSalary').addClass('requiredField');


                    $('#ddlWriteOffAndDeductApply').val(DoctorWiseConfiguration[0].IsWriteOffAndDeductApply);

                    var $template = $('#templateDiscBearedBy').parseTemplate(DoctorWiseConfiguration);
                    $('#divDiscBearedByData').html($template).customFixedHeader();
                    bindUnitDoctorSetup(function () {
                        setCategoryTotal(function () { });
                    });
                    bindMappedDiscBearedBy(function () { });
                    MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                    $('#divDoctorConfigurationData').show();
                }
                else {
                    CategoryData = CategoryWiseReferralWise;
                    var $template = $('#templateCategoryWiseReferralWiseDoctorShare').parseTemplate(CategoryData);

                    $('#divServiceTypeData').html($template).customFixedHeader();
                    MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                }
                $('.isSave').show();
            }

        }

        var bindSubCategoryWiseReferralWiseDoctorShareGrid = function (CategoryID, CategoryName, selectedRow) {
            $('#divSubCategoryWiseData').html('');
            bindDoctorShareCentreWiseDoctorWise(2, CategoryID, 0, function () {
                if (SubCategoryWiseReferralWise.length > 0) {

                    if (SubCategoryWiseReferralWise[0].ServiceType == 2) {

                        if ($(selectedRow).closest('tr').find('#chkExcludeCat').is(':checked')) {
                            modelAlert("Please Select Only Un-Excluded Category !!!");
                        }
                        else {
                            $('#divExcludePackageSubCategory,#divExcludePackageItem').html('');
                            $('#tblExcCategoryWise tbody tr').removeClass('selectedRow');
                            $(selectedRow).closest('tr').addClass('selectedRow');

                            ExcludeSubCategories = SubCategoryWiseReferralWise;
                            var $template = $('#templateExcludeSubCategory').parseTemplate(ExcludeSubCategories);
                            $('#divExcludePackageSubCategory').html($template).customFixedHeader();
                            MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                        }
                    }
                    else {

                        $('#txtSubCategorySearch').val('');
                        SubCategoryData = SubCategoryWiseReferralWise;
                        $('#tblCategoryWise tbody tr td').removeClass('selectedRow');
                        $(selectedRow).addClass('selectedRow');

                        var $template = $('#templateSubCategoryWiseReferralWiseDoctorShare').parseTemplate(SubCategoryData);
                        $('#divSubCategoryWiseData').html($template).customFixedHeader();
                        MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });

                        $('#spnSubCategoryHeader').html('Category : <span class="patientInfo">' + CategoryName + '</span> , Doctor :  <span class="patientInfo">' + $('#ddlDoctor option:selected').text() + '</span> ,Share Type :  <span class="patientInfo">' + $('#ddlType option:selected').text() + ' (' + $('#ddlPanel option:selected').text() + ')</span>');
                        $('#divSubCategoryDetails').showModel();
                    }
                }
                else {
                    modelAlert('No Sub-Category Exist in the Selected Category');
                }
            });
        }
        var bindItemWiseReferralWiseDoctorShareGrid = function (CategoryID, SubCategoryID, SubCategoryName, selectedRow) {
            $('#divItemWiseData').html('');
            bindDoctorShareCentreWiseDoctorWise(3, CategoryID, SubCategoryID, function () {
                if (ItemWiseReferralWise.length > 0) {
                    if (ItemWiseReferralWise[0].ServiceType == 2) {

                        if ($(selectedRow).closest('tr').find('#chkExcludeSubCat').is(':checked')) {
                            modelAlert("Please Select Only Un-Excluded Sub-Category !!!");
                        }
                        else {
                            $('#divExcludePackageItem').html('');
                            $('#tblExcSubCategoryWise tbody tr').removeClass('selectedRow');
                            $(selectedRow).closest('tr').addClass('selectedRow');

                            ExcludeItem = ItemWiseReferralWise;
                            var $template = $('#templateExcludeItem').parseTemplate(ExcludeItem);
                            $('#divExcludePackageItem').html($template).customFixedHeader();
                            MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                        }
                    }
                    else {

                        $('#txtItemSearch').val('');

                        ItemData = ItemWiseReferralWise;
                        $('#tblSubCategoryWise tbody tr td').removeClass('selectedRow');
                        $(selectedRow).addClass('selectedRow');

                        var $template = $('#templateItemWiseReferralWiseDoctorShare').parseTemplate(ItemData);
                        $('#divItemWiseData').html($template).customFixedHeader();
                        MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });

                        $('#spnItemHeader').html('Sub-Category : <span class="patientInfo">' + SubCategoryName + '</span> , Doctor :  <span class="patientInfo">' + $('#ddlDoctor option:selected').text() + '</span> ,Share Type :  <span class="patientInfo">' + $('#ddlType option:selected').text() + ' (' + $('#ddlPanel option:selected').text() + ')</span>');
                        $('#divItemDetails').showModel();
                    }
                }
                else {
                    modelAlert('No Item Exist in the Selected Sub-Category');
                }
            });
        }


        var bindMappedDiscBearedBy = function () {
            $('#divDiscBearedByData').find('#tblDiscBearedBy tbody tr').each(function (i, r) {
                var rowId = $(this);
                var tdData = JSON.parse(rowId.find('#tdDiscCatData').text());
                checkBoxList = rowId.find('#ddlDiscBearedBy').val(tdData.DiscountBearedBy);
            });

        }


        var AllShareChange = function (ctrl, className) {

            var classNameOld = className;

            $("." + className).val(Number($(ctrl).val()));

            var ctrlID = $(ctrl).attr('id');
            if (ctrlID.indexOf("Per") != -1) {
                ctrlID = ctrlID.replace("Per", "Amt")
                className = className.replace("Per", "Amt")
            }
            else {
                ctrlID = ctrlID.replace("Amt", "Per")
                className = className.replace("Amt", "Per")
            }

            $('#' + ctrlID).val('0');
            $('.' + className).val('0');


            if (classNameOld == 'UnitOPDSharePer' || classNameOld == 'UnitIPDSharePer' || classNameOld == 'UnitEMGSharePer')
            {
                setCategoryTotal(function () { });
            }
            else
            {
                setCheckBoxSelection(ctrl,function() {});
            }
        }

        var setCheckBoxSelection = function (ctrl) {

            var totalvalue = 0;
            if ($(ctrl).attr('id').indexOf("txtCat") != -1)
            {

                $('#divServiceTypeData').find('#tblCategoryWise tbody tr').each(function (i, r) {
                    totalvalue = 0;
                    $(this).find('input[type=text]').each(function (i, r) {
                        totalvalue = totalvalue + Number($(this).attr('value'));
                    });

                    if (totalvalue > 0)
                        $(this).find('input[type=checkbox]').prop('checked', true);
                    else
                        $(this).find('input[type=checkbox]').prop('checked', false);
                });

            }
            else if ($(ctrl).attr('id').indexOf("txtSubCat") != -1)
            {
                $('#divSubCategoryWiseData').find('#tblSubCategoryWise tbody tr').each(function (i, r) {
                    totalvalue = 0;
                    $(this).find('input[type=text]').each(function (i, r) {
                        totalvalue = totalvalue + Number($(this).attr('value'));
                    });

                    if (totalvalue > 0)
                        $(this).find('input[type=checkbox]').prop('checked', true);
                    else
                        $(this).find('input[type=checkbox]').prop('checked', false);
                });
            }
            else if ($(ctrl).attr('id').indexOf("txtItem") != -1) {
                $('#divItemWiseData').find('#tblItemWise tbody tr').each(function (i, r) {
                    totalvalue = 0;
                    $(this).find('input[type=text]').each(function (i, r) {
                        totalvalue = totalvalue + Number($(this).attr('value'));
                    });

                    if (totalvalue > 0)
                        $(this).find('input[type=checkbox]').prop('checked', true);
                    else
                        $(this).find('input[type=checkbox]').prop('checked', false);
                });
            }
        }

        var ValidateValues = function (ctrl) {

            //dsk
            var ctrlID = $(ctrl).attr('id');
            if (ctrlID.indexOf("Per") != -1) 
                ctrlID= ctrlID.replace("Per", "Amt")
            else
                ctrlID= ctrlID.replace("Amt", "Per")

            $(ctrl).closest('tr').find('#' + ctrlID).val('0');


            var totalvalue = 0;
            $(ctrl).closest('tr').find('input[type=text]').each(function (i, r) {
                totalvalue = totalvalue+Number($(this).attr('value'));
            });

            if(totalvalue>0)
                $(ctrl).closest('tr').find('input[type=checkbox]').prop('checked', true);
            else
                $(ctrl).closest('tr').find('input[type=checkbox]').prop('checked', false);

        }

        var checkAll = function (checkStatus, GridType) {
            if (Number(GridType) == 0)
                $('.chkCat').prop('checked', checkStatus);
            else if (Number(GridType) == 1)
                $('.chkSubCat').prop('checked', checkStatus);
            else if (Number(GridType) == 2)
                $('.chkItem').prop('checked', checkStatus);
            else if (Number(GridType) == 3) {
                $('#tblExcCategoryWise tbody tr').removeClass('selectedRow');
                $('.chkExcludeCat').prop('checked', checkStatus);
                $('#divExcludePackageSubCategory,#divExcludePackageItem').html('');
            }
            else if (Number(GridType) == 4) {
                $('#tblExcSubCategoryWise tbody tr').removeClass('selectedRow');
                $('.chkExcludeSubCat').prop('checked', checkStatus);
                $('#divExcludePackageItem').html('');
            }
            else if (Number(GridType) == 5)
                $('.chkExcludeItem').prop('checked', checkStatus);
        }

        
        var validateSelection = function (ctrl) {

            if($(ctrl).closest('tr').attr('class') == 'selectedRow')
                $(ctrl).prop('checked', false);
        }
        var saveDoctorShare = function (btnSave, GridType) {
            $(btnSave).attr('disabled', true).val('Submitting...');

            if(Number($('#ddlServiceType').val()) ==1 || Number($('#ddlServiceType').val()) ==3) {
                getDoctorShareDetails(GridType, function (data) {
                    serverCall('DoctorShareSetupNew.aspx/saveDoctorShare', data, function (resposne) {
                        var responseData = JSON.parse(resposne);
                        modelAlert(responseData.response, function () {
                            if (responseData.status) {
                                modelConfirmation('Confirmation ?', 'Do you want to re-calculate doctor sharing', 'Yes', 'No', function (response) {
                                    if (response) {
                                        $('#spnReCalculateDoctorID').text($('#ddlDoctor').val());
                                        $('#spnReCalculateCentreID').text($('#ddlCentre').val());
                                        $('#spnReCalculateDoctorName').text('Doctor Name : ' + $('#ddlDoctor option:selected').text());
                                        $("#divRecalculateModel").show();
                                        $(btnSave).removeAttr('disabled').val('Save');
                                    }
                                    else {
                                        window.location.reload();
                                    }
                                });
                            }
                            else
                                $(btnSave).removeAttr('disabled').val('Save');
                        });
                    });
                });
            }
            else if (Number($('#ddlServiceType').val()) == 2) {
                getExcludeDetails(function (data) {
                    serverCall('DoctorShareSetupNew.aspx/saveExcludePackageDetails', data, function (resposne) {
                        var responseData = JSON.parse(resposne);
                        modelAlert(responseData.response, function () {
                            if (responseData.status) 
                                window.location.reload();
                            else
                                $(btnSave).removeAttr('disabled').val('Save');
                        });
                    });
                });
            }
            else if (Number($('#ddlServiceType').val()) == 4) {

                if (Number($('#ddlShareCategory').val()) == 2 && Number($('#txtSalary').val()) == 0) {
                    $('#txtSalary').focus();
                    modelAlert('Please Enter Salary');
                    return false;
                }

                checkUnitValidation(function (validationStatus) {
                    if (validationStatus) {
                        getDoctorConfigurationDetails(function (data) {
                            serverCall('DoctorShareSetupNew.aspx/saveDoctorConfiguration', data, function (resposne) {
                                var responseData = JSON.parse(resposne);
                                modelAlert(responseData.response, function () {
                                    if (responseData.status)
                                        window.location.reload();
                                    else
                                        $(btnSave).removeAttr('disabled').val('Save');
                                });
                            });
                        });
                    }
                    else {
                        modelAlert("All Total of Unit Doctor`s Share should be 100 !!!");
                        $(btnSave).removeAttr('disabled').val('Save');

                    }
                });
            }

        }


        var reCalculateDoctorShare = function (btnSave) {

            if ($('#txtApplyMonth').val() == "" || $('#txtApplyMonth').val().indexOf('/') == -1 || Number($('#txtApplyMonth').val().length) !=5)
            {
                modelAlert('Please Enter Valid Month !!!');
                $('#txtApplyMonth').focus();
                return false;
            }
           
            $(btnSave).attr('disabled', true).val('Submitting...');

            data = {
                doctorID : Number($('#spnReCalculateDoctorID').text()),
                centreID : Number($('#spnReCalculateCentreID').text()),
                year: "20" + $('#txtApplyMonth').val().split('/')[1],
                month : $('#txtApplyMonth').val().split('/')[0]
            }

            serverCall('DoctorShareSetupNew.aspx/ReCalculateDoctorWiseShare', data, function (resposne) {
                    var responseData = JSON.parse(resposne);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) 
                            window.location.reload();
                        else
                            $(btnSave).removeAttr('disabled').val('Re-Calculate');
                    });
                });
        }
        var checkUnitValidation = function (callback) {
            var IsCorrect = 1;
            $('#tblUnitDoctorSetup tbody .IsTotalRows').each(function (i, r) {
                if (Number($(this).find('#spnTotalIsCorrect').text()) == 0)
                    IsCorrect = 0;
            });

            if (IsCorrect == 1)
                callback(true);
            else
                callback(false);
        }
        var setCategoryTotal = function () {

            var PreCategoryID = 0;
            var CurrentCategoryID = 0;
            var OPDSharePer = 0;
            var IPDSharePer = 0;
            var EMGSharePer = 0;

            var TotalRows = $('#tblUnitDoctorSetup tbody .IsActual').length;

            $('#tblUnitDoctorSetup tbody .IsActual').each(function (i, r) {
                var tdData = JSON.parse($(this).find('#tdUnitData').text());
                if (i == 0) {
                    PreCategoryID = tdData.CategoryID;
                    CurrentCategoryID = tdData.CategoryID;
                    OPDSharePer = Number($(this).find('#txtUnitOPDSharePer').val());
                    IPDSharePer = Number($(this).find('#txtUnitIPDSharePer').val());
                    EMGSharePer = Number($(this).find('#txtUnitEMGSharePer').val());
                    if (i == TotalRows - 1) {
                        $('#tblUnitDoctorSetup').find('#trTotal_' + CurrentCategoryID).find('#spnTotal_OPD').text(OPDSharePer);
                        $('#tblUnitDoctorSetup').find('#trTotal_' + CurrentCategoryID).find('#spnTotal_IPD').text(IPDSharePer);
                        $('#tblUnitDoctorSetup').find('#trTotal_' + CurrentCategoryID).find('#spnTotal_EMG').text(EMGSharePer);

                        if (Number(OPDSharePer) == 100 && (Number(IPDSharePer) == 100 && Number(EMGSharePer) == 100))
                            $('#tblUnitDoctorSetup').find('#trTotal_' + CurrentCategoryID).find('#spnTotalIsCorrect').text('1');
                        else
                            $('#tblUnitDoctorSetup').find('#trTotal_' + CurrentCategoryID).find('#spnTotalIsCorrect').text('0');
                    }
                }
                else {
                       CurrentCategoryID = tdData.CategoryID;
                    if (PreCategoryID != CurrentCategoryID) {
                        $('#tblUnitDoctorSetup').find('#trTotal_' + PreCategoryID).find('#spnTotal_OPD').text(OPDSharePer);
                        $('#tblUnitDoctorSetup').find('#trTotal_' + PreCategoryID).find('#spnTotal_IPD').text(IPDSharePer);
                        $('#tblUnitDoctorSetup').find('#trTotal_' + PreCategoryID).find('#spnTotal_EMG').text(EMGSharePer);
                        if (Number(OPDSharePer) == 100 && (Number(IPDSharePer) == 100 && Number(EMGSharePer) == 100))
                            $('#tblUnitDoctorSetup').find('#trTotal_' + PreCategoryID).find('#spnTotalIsCorrect').text('1');
                        else
                            $('#tblUnitDoctorSetup').find('#trTotal_' + PreCategoryID).find('#spnTotalIsCorrect').text('0');

                        PreCategoryID = CurrentCategoryID;
                        OPDSharePer = Number($(this).find('#txtUnitOPDSharePer').val());
                        IPDSharePer = Number($(this).find('#txtUnitIPDSharePer').val());
                        EMGSharePer = Number($(this).find('#txtUnitEMGSharePer').val());

                    }
                    else {
                        OPDSharePer = OPDSharePer + Number($(this).find('#txtUnitOPDSharePer').val());
                        IPDSharePer = IPDSharePer + Number($(this).find('#txtUnitIPDSharePer').val());
                        EMGSharePer = EMGSharePer + Number($(this).find('#txtUnitEMGSharePer').val());

                        if (i == TotalRows - 1) {
                            $('#tblUnitDoctorSetup').find('#trTotal_' + CurrentCategoryID).find('#spnTotal_OPD').text(OPDSharePer);
                            $('#tblUnitDoctorSetup').find('#trTotal_' + CurrentCategoryID).find('#spnTotal_IPD').text(IPDSharePer);
                            $('#tblUnitDoctorSetup').find('#trTotal_' + CurrentCategoryID).find('#spnTotal_EMG').text(EMGSharePer);
                            if (Number(OPDSharePer) == 100 && (Number(IPDSharePer) == 100 && Number(EMGSharePer) == 100))
                                $('#tblUnitDoctorSetup').find('#trTotal_' + CurrentCategoryID).find('#spnTotalIsCorrect').text('1');
                            else
                                $('#tblUnitDoctorSetup').find('#trTotal_' + CurrentCategoryID).find('#spnTotalIsCorrect').text('0');
                        }
                    }
                }
            });
        }
        var getDoctorShareDetails = function (GridType,callback) {

            var doctorShareList = [];

            if (GridType == 1) {
                $('#divServiceTypeData').find('#tblCategoryWise tbody tr').each(function (i, r) {
                    var tdData = JSON.parse($(this).find('#tdCatRowData').text());
                    if ($(this).find('#chkCat').is(':checked')) {
                        doctorShareList.push({
                            CentreID: tdData.CentreID,
                            DoctorID: tdData.DoctorID,
                            ShareType: tdData.ShareType,
                            ServiceType: tdData.ServiceType,
                            PanelGroupID: tdData.PanelGroupID,
                            PanelID: tdData.PanelID,
                            ReferralTypeID: tdData.ReferralTypeID,
                            CategoryID: tdData.CategoryID,
                            SubCategoryID: tdData.SubCategoryID,
                            ItemID: tdData.ItemID,
                            OPDSharePer: Number($(this).find('#txtCatOPDSharePer').val()),
                            OPDShareAmt: Number($(this).find('#txtCatOPDShareAmt').val()),
                            OPDBonusPer: Number($(this).find('#txtCatOPDBonusPer').val()),
                            OPDBonusAmt: Number($(this).find('#txtCatOPDBonusAmt').val()),
                            IPDSharePer: Number($(this).find('#txtCatIPDSharePer').val()),
                            IPDShareAmt: Number($(this).find('#txtCatIPDShareAmt').val()),
                            IPDBonusPer: Number($(this).find('#txtCatIPDBonusPer').val()),
                            IPDBonusAmt: Number($(this).find('#txtCatIPDBonusAmt').val()),
                            EMGSharePer: Number($(this).find('#txtCatEMGSharePer').val()),
                            EMGShareAmt: Number($(this).find('#txtCatEMGShareAmt').val()),
                            EMGBonusPer: Number($(this).find('#txtCatEMGBonusPer').val()),
                            EMGBonusAmt: Number($(this).find('#txtCatEMGBonusAmt').val()),
                            IsCheck: 1,
                            GridType: tdData.ServiceType == 1 ? 1 : 3
                        });
                    }
                });

                if (doctorShareList.length == 0) {
                    var tdData = JSON.parse($($('#divServiceTypeData').find('#tblCategoryWise tbody tr').each(function (i, r) { })[0]).find('#tdCatRowData').text());
                    doctorShareList.push({
                        CentreID: tdData.CentreID,
                        DoctorID: tdData.DoctorID,
                        ShareType: tdData.ShareType,
                        ServiceType: tdData.ServiceType,
                        PanelGroupID: tdData.PanelGroupID,
                        PanelID: tdData.PanelID,
                        ReferralTypeID: tdData.ReferralTypeID,
                        CategoryID: tdData.CategoryID,
                        SubCategoryID: tdData.SubCategoryID,
                        ItemID: tdData.ItemID,
                        OPDSharePer: 0,
                        OPDShareAmt: 0,
                        OPDBonusPer: 0,
                        OPDBonusAmt: 0,
                        IPDSharePer: 0,
                        IPDShareAmt: 0,
                        IPDBonusPer: 0,
                        IPDBonusAmt: 0,
                        EMGSharePer: 0,
                        EMGShareAmt: 0,
                        EMGBonusPer: 0,
                        EMGBonusAmt: 0,
                        IsCheck: 0,
                        GridType: GridType
                    });
                }
            }
            else if (GridType == 2) {
                $('#divSubCategoryWiseData').find('#tblSubCategoryWise tbody tr').each(function (i, r) {
                    var tdData = JSON.parse($(this).find('#tdSubCatRowData').text());
                    if ($(this).find('#chkSubCat').is(':checked')) {
                        doctorShareList.push({
                            CentreID: tdData.CentreID,
                            DoctorID: tdData.DoctorID,
                            ShareType: tdData.ShareType,
                            ServiceType: tdData.ServiceType,
                            PanelGroupID: tdData.PanelGroupID,
                            PanelID: tdData.PanelID,
                            ReferralTypeID: tdData.ReferralTypeID,
                            CategoryID: tdData.CategoryID,
                            SubCategoryID: tdData.SubCategoryID,
                            ItemID: tdData.ItemID,
                            OPDSharePer: Number($(this).find('#txtSubCatOPDSharePer').val()),
                            OPDShareAmt: Number($(this).find('#txtSubCatOPDShareAmt').val()),
                            OPDBonusPer: Number($(this).find('#txtSubCatOPDBonusPer').val()),
                            OPDBonusAmt: Number($(this).find('#txtSubCatOPDBonusAmt').val()),
                            IPDSharePer: Number($(this).find('#txtSubCatIPDSharePer').val()),
                            IPDShareAmt: Number($(this).find('#txtSubCatIPDShareAmt').val()),
                            IPDBonusPer: Number($(this).find('#txtSubCatIPDBonusPer').val()),
                            IPDBonusAmt: Number($(this).find('#txtSubCatIPDBonusAmt').val()),
                            EMGSharePer: Number($(this).find('#txtSubCatEMGSharePer').val()),
                            EMGShareAmt: Number($(this).find('#txtSubCatEMGShareAmt').val()),
                            EMGBonusPer: Number($(this).find('#txtSubCatEMGBonusPer').val()),
                            EMGBonusAmt: Number($(this).find('#txtSubCatEMGBonusAmt').val()),
                            IsCheck: 1,
                            GridType: GridType
                        });
                    }
                });


                if (doctorShareList.length == 0) {
                    var tdData = JSON.parse($($('#divSubCategoryWiseData').find('#tblSubCategoryWise tbody tr').each(function (i, r) { })[0]).find('#tdSubCatRowData').text());
                    doctorShareList.push({
                        CentreID: tdData.CentreID,
                        DoctorID: tdData.DoctorID,
                        ShareType: tdData.ShareType,
                        ServiceType: tdData.ServiceType,
                        PanelGroupID: tdData.PanelGroupID,
                        PanelID: tdData.PanelID,
                        ReferralTypeID: tdData.ReferralTypeID,
                        CategoryID: tdData.CategoryID,
                        SubCategoryID: tdData.SubCategoryID,
                        ItemID: tdData.ItemID,
                        OPDSharePer: 0,
                        OPDShareAmt: 0,
                        OPDBonusPer: 0,
                        OPDBonusAmt: 0,
                        IPDSharePer: 0,
                        IPDShareAmt: 0,
                        IPDBonusPer: 0,
                        IPDBonusAmt: 0,
                        EMGSharePer: 0,
                        EMGShareAmt: 0,
                        EMGBonusPer: 0,
                        EMGBonusAmt: 0,
                        IsCheck: 0,
                        GridType: GridType
                    });
                }
            }
            else if (GridType == 3) {
                $('#divItemWiseData').find('#tblItemWise tbody tr').each(function (i, r) {
                    var tdData = JSON.parse($(this).find('#tdItemRowData').text());
                    if ($(this).find('#chkItem').is(':checked')) {
                        doctorShareList.push({
                            CentreID: tdData.CentreID,
                            DoctorID: tdData.DoctorID,
                            ShareType: tdData.ShareType,
                            ServiceType: tdData.ServiceType,
                            PanelGroupID: tdData.PanelGroupID,
                            PanelID: tdData.PanelID,
                            ReferralTypeID: tdData.ReferralTypeID,
                            CategoryID: tdData.CategoryID,
                            SubCategoryID: tdData.SubCategoryID,
                            ItemID: tdData.ItemID,
                            OPDSharePer: Number($(this).find('#txtItemOPDSharePer').val()),
                            OPDShareAmt: Number($(this).find('#txtItemOPDShareAmt').val()),
                            OPDBonusPer: Number($(this).find('#txtItemOPDBonusPer').val()),
                            OPDBonusAmt: Number($(this).find('#txtItemOPDBonusAmt').val()),
                            IPDSharePer: Number($(this).find('#txtItemIPDSharePer').val()),
                            IPDShareAmt: Number($(this).find('#txtItemIPDShareAmt').val()),
                            IPDBonusPer: Number($(this).find('#txtItemIPDBonusPer').val()),
                            IPDBonusAmt: Number($(this).find('#txtItemIPDBonusAmt').val()),
                            EMGSharePer: Number($(this).find('#txtItemEMGSharePer').val()),
                            EMGShareAmt: Number($(this).find('#txtItemEMGShareAmt').val()),
                            EMGBonusPer: Number($(this).find('#txtItemEMGBonusPer').val()),
                            EMGBonusAmt: Number($(this).find('#txtItemEMGBonusAmt').val()),
                            IsCheck: 1,
                            GridType: GridType
                        });
                    }
                });

                if (doctorShareList.length == 0) {
                    var tdData = JSON.parse($($('#divItemWiseData').find('#tblItemWise tbody tr').each(function (i, r) { })[0]).find('#tdItemRowData').text());
                    doctorShareList.push({
                        CentreID: tdData.CentreID,
                        DoctorID: tdData.DoctorID,
                        ShareType: tdData.ShareType,
                        ServiceType: tdData.ServiceType,
                        PanelGroupID: tdData.PanelGroupID,
                        PanelID: tdData.PanelID,
                        ReferralTypeID: tdData.ReferralTypeID,
                        CategoryID: tdData.CategoryID,
                        SubCategoryID: tdData.SubCategoryID,
                        ItemID: tdData.ItemID,
                        OPDSharePer: 0,
                        OPDShareAmt: 0,
                        OPDBonusPer: 0,
                        OPDBonusAmt: 0,
                        IPDSharePer: 0,
                        IPDShareAmt: 0,
                        IPDBonusPer: 0,
                        IPDBonusAmt: 0,
                        EMGSharePer: 0,
                        EMGShareAmt: 0,
                        EMGBonusPer: 0,
                        EMGBonusAmt: 0,
                        IsCheck: 0,
                        GridType: GridType
                    });
                }
            }


            callback({ DoctorShare: doctorShareList });
        }


        var getExcludeDetails = function (callback) {

            var categoryID = 0;
            var subCategoryID = 0;

            var ExcludeDetails = [];

                $('#divExcludePackageCategory').find('#tblExcCategoryWise tbody tr').each(function (i, r) {
                    var tdData = JSON.parse($(this).find('#tdExcCatData').text());
                    if ($(this).find('#chkExcludeCat').is(':checked')) {
                        ExcludeDetails.push({
                            CentreID: tdData.CentreID,
                            ShareType: tdData.ShareType,
                            PanelGroupID: tdData.PanelGroupID,
                            PanelID: tdData.PanelID,
                            PackageID: tdData.PackageID,
                            CategoryID: tdData.CategoryID,
                            SubCategoryID: tdData.SubCategoryID,
                            ItemID: tdData.ItemID
                        });
                    }
                });
            
                $('#divExcludePackageSubCategory').find('#tblExcSubCategoryWise tbody tr').each(function (i, r) {
                    var tdData = JSON.parse($(this).find('#tdExcSubCatData').text());
                    categoryID = tdData.CategoryID;

                    if ($(this).find('#chkExcludeSubCat').is(':checked')) {
                        ExcludeDetails.push({
                            CentreID: tdData.CentreID,
                            ShareType: tdData.ShareType,
                            PanelGroupID: tdData.PanelGroupID,
                            PanelID: tdData.PanelID,
                            PackageID: tdData.PackageID,
                            CategoryID: tdData.CategoryID,
                            SubCategoryID: tdData.SubCategoryID,
                            ItemID: tdData.ItemID
                        });
                    }
                });
            
          
                $('#divExcludePackageItem').find('#tblExcItemWise tbody tr').each(function (i, r) {
                    var tdData = JSON.parse($(this).find('#tdExcItemData').text());
                    subCategoryID = tdData.SubCategoryID;
                    if ($(this).find('#chkExcludeItem').is(':checked')) {
                        ExcludeDetails.push({
                            CentreID: tdData.CentreID,
                            ShareType: tdData.ShareType,
                            PanelGroupID: tdData.PanelGroupID,
                            PanelID: tdData.PanelID,
                            PackageID: tdData.PackageID,
                            CategoryID: tdData.CategoryID,
                            SubCategoryID: tdData.SubCategoryID,
                            ItemID: tdData.ItemID
                        });
                    }
                });

                callback({ excludeDetails: ExcludeDetails, CategoryID: categoryID, SubCategoryID: subCategoryID });
        }

        var getDoctorConfigurationDetails = function (callback) {
            var DoctorConfiguration= [];
            var UnitDoctorSharing = [];
            $('#divDiscBearedByData').find('#tblDiscBearedBy tbody tr').each(function (i, r) {
                var tdData = JSON.parse($(this).find('#tdDiscCatData').text());
                DoctorConfiguration.push({
                    DoctorID: tdData.DoctorID,
                    CentreID: tdData.CentreID,
                    CategoryID: tdData.CategoryID,
                    DiscountBearedBy: Number($(this).find('#ddlDiscBearedBy').val())
                });
            });

            $('#tblUnitDoctorSetup tbody .IsActual').each(function (i, r) {
                var tdData = JSON.parse($(this).find('#tdUnitData').text());
                UnitDoctorSharing.push({
                    DoctorID: tdData.DoctorID,
                    CentreID: tdData.CentreID,
                    UnitDoctorsID: tdData.UnitDoctorID,
                    CategoryID: tdData.CategoryID,
                    OPDSharePer: Number($(this).find('#txtUnitOPDSharePer').val()),
                    IPDSharePer: Number($(this).find('#txtUnitIPDSharePer').val()),
                    EMGSharePer: Number($(this).find('#txtUnitEMGSharePer').val())
                });
            });

            callback({ DoctorConfiguration: DoctorConfiguration,UnitDoctorSharing:UnitDoctorSharing, ShareCategory: Number($('#ddlShareCategory').val()), Salary: Number($('#txtSalary').val()), ShareCalculationType: Number($('#ddlShareCalculationType').val()), IsWriteOffAndDeductApply: Number($('#ddlWriteOffAndDeductApply').val()) });
        }

    </script>


    <script id="templateDiscBearedBy" type="text/html">

     <table class="GridViewStyle FixedTables" cellspacing="0" width="100%" rules="all" border="1" id="tblDiscBearedBy" style="width:100%;border-collapse:collapse;">
		<#if(DoctorWiseConfiguration.length>0){#>

		<thead>
                <tr>
                    <th class='GridViewHeaderStyle' style=" text-align:center;" colspan="4">Discount Beared By Setting</th>
                 </tr>
                <tr>
                    <th class='GridViewHeaderStyle' style="width:30px;"> S/No.</th>
                    <th class='GridViewHeaderStyle' style="text-align:left" >Category</th>
                    <th class='GridViewHeaderStyle' style="width:155px;" >Discount Beared By</th>
                    <th class='GridViewHeaderStyle' style="display:none">data</th>
                 </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=DoctorWiseConfiguration.length;
		window.status="Total Records Found :"+ dataLength;
		var objDiscBearedByRow ;
		var status;
		for(var g=0;g<dataLength;g++)
		{
		objDiscBearedByRow = DoctorWiseConfiguration[g];
		#>
		    <tr  onmouseover="this.style.color='#00F'" onMouseOut="this.style.color=''" id="<#=g+1#>" style='cursor:pointer; background-color:white;'>
               <td id="tdDiscCatIndex" class="GridViewLabItemStyle" style="text-align:center;"><#=g+1#></td>
		       <td id="tdDiscCategoryName" class="GridViewLabItemStyle" style="text-align:left;"><#=objDiscBearedByRow.CategoryName#></td>
		       <td id="tdDiscBearedBy" class="GridViewLabItemStyle" style="text-align:center;">
                    <select id="ddlDiscBearedBy" >
                        <option value="1" selected="selected">Both</option>
                        <option value="2">Doctor</option>
                        <option value="3">Hospital</option>
                    </select> 
		       </td>
               <td id="tdDiscCatData" class="GridViewLabItemStyle" style="text-align:center;display:none"><#= JSON.stringify(objDiscBearedByRow) #></td>          
			</tr>   
        <#}#>
        </tbody>
    </table>
	</script>

     <script id="templateUnitDoctorSetup" type="text/html">

     <table class="GridViewStyle FixedTables" cellspacing="0" width="100%" rules="all" border="1" id="tblUnitDoctorSetup" style="width:100%;border-collapse:collapse;">
		<#if(UnitDoctorSetup.length>0){#>

		<thead>
                 <tr>
                    <th class='GridViewHeaderStyle' style=" text-align:center;" colspan="7">Unit Doctor`s Sharing</th>
                 </tr>
                <tr>
                    <th class='GridViewHeaderStyle' style="text-align:left; width:200px" rowspan="2" >&nbsp;Category</th>
		            <th class='GridViewHeaderStyle' style="text-align:left; width:300px" rowspan="2" >&nbsp;Doctor`s</th>
                    <th class='GridViewHeaderStyle' >OPD(%)</th>
 		            <th class='GridViewHeaderStyle' >IPD(%)</th>
 		            <th class='GridViewHeaderStyle' >EMG(%)</th>
                    <th class='GridViewHeaderStyle' style="display:none" rowspan="2">data</th>
                 </tr>

                <tr>
                    <th class="GridViewHeaderStyle" style="text-align:center;"><input type="text" id="txtUnitOPDSharePerAll" onkeyup="AllShareChange(this,'UnitOPDSharePer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
		        	<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtUnitIPDSharePerAll" onkeyup="AllShareChange(this,'UnitIPDSharePer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtUnitEMGSharePerAll" onkeyup="AllShareChange(this,'UnitEMGSharePer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
                </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=UnitDoctorSetup.length;
		window.status="Total Records Found :"+ dataLength;
		var objUnitDoctorSetupRow ;
		var status;
		for(var s=0;s<dataLength;s++)
		{
		objUnitDoctorSetupRow = UnitDoctorSetup[s];
		#>

		    <tr  onmouseover="this.style.color='#00F'" onMouseOut="this.style.color=''" class="<#=objUnitDoctorSetupRow.CategoryID#> IsActual" id="<#=s+1#>" style='cursor:pointer; background-color:white;'>
               	
                <# if(s>0) { if(UnitDoctorSetup[s].CategoryID !=UnitDoctorSetup[s-1].CategoryID){#> <td id="tdUnitCategoryName" rowspan='<#=objUnitDoctorSetupRow.TotalDoctors#>' class="GridViewLabItemStyle" style="text-align:left; font-weight:bold;"><#=objUnitDoctorSetupRow.CategoryName#>  </td> <#}} else {#> <td id="tdUnitCategoryName" rowspan='<#=objUnitDoctorSetupRow.TotalDoctors#>' class="GridViewLabItemStyle" style="text-align:left; font-weight:bold;"><#=objUnitDoctorSetupRow.CategoryName#>  </td> <#} #>

		        <td id="tdUnitDoctorName" class="GridViewLabItemStyle" style="text-align:left; width:300px; max-width: 300px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" data-title='<#=objUnitDoctorSetupRow.DoctorName#>' "><#=objUnitDoctorSetupRow.DoctorName#></td>
		        <td id="tdUnitOPDPer" class="GridViewLabItemStyle" style="text-align:center;">
                    <input type="text" class="UnitOPDSharePer ItDoseTextinputNum" id="txtUnitOPDSharePer" onkeyup="setCategoryTotal(function(){});" value='<#=objUnitDoctorSetupRow.OPDSharePer#>' onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' />
		        </td>
			    <td id="tdUnitIPDPer" class="GridViewLabItemStyle" style="text-align:center;">
                    <input type="text" class="UnitIPDSharePer ItDoseTextinputNum" id="txtUnitIPDSharePer" onkeyup="setCategoryTotal(function(){});" value='<#=objUnitDoctorSetupRow.IPDSharePer#>' onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' />
		        </td>
			    <td id="tdUnitEMGPer" class="GridViewLabItemStyle" style="text-align:center;">
                    <input type="text" class="UnitEMGSharePer ItDoseTextinputNum" id="txtUnitEMGSharePer" onkeyup="setCategoryTotal(function(){});" value='<#=objUnitDoctorSetupRow.EMGSharePer#>' onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' />
		        </td>
               	<td id="tdUnitData" class="GridViewLabItemStyle" style="text-align:center;display:none"><#= JSON.stringify(objUnitDoctorSetupRow) #></td>          
			</tr>  
            
           <#  if(s>0) {if((s+1)%(objUnitDoctorSetupRow.TotalDoctors-1)==0){#> 
            <tr  onmouseover="this.style.color='#00F'" onMouseOut="this.style.color=''" class="IsTotalRows" id="trTotal_<#=objUnitDoctorSetupRow.CategoryID#>" style='cursor:pointer; background-color:white;'>
             
                <td id="tdTotal_<#=objUnitDoctorSetupRow.CategoryID#>" class="GridViewHeaderStyle " style="text-align:right; background-color:#06a9de">Total :&nbsp;</td>
		        <td id="tdTotal_OPD" class="GridViewHeaderStyle" style="text-align:right; background-color:#06a9de">
                    <span id="spnTotal_OPD">0</span>
		        </td>
			    <td id="tdTotal_IPD" class="GridViewHeaderStyle" style="text-align:right; background-color:#06a9de">
                    <span id="spnTotal_IPD">0</span>
		        </td>
			    <td id="tdTotal_EMG" class="GridViewHeaderStyle" style="text-align:right; background-color:#06a9de">
                    <span id="spnTotal_EMG">0</span>
                 </td>
               	<td id="tdTotal_Data" class="GridViewHeaderStyle" style="text-align:center;display:none">
                    <span id="spnTotalIsCorrect">0</span>
               	</td> 

            </tr>
               	
             <#}}#>
        <#}#>
        </tbody>
    </table>
</script>
 <script id="templateExcludeCategory" type="text/html">

     <table class="GridViewStyle FixedTables" cellspacing="0" width="100%" rules="all" border="1" id="tblExcCategoryWise" style="width:100%;border-collapse:collapse;">
		<#if(ExcludeCategories.length>0){#>

		<thead>
                <tr>
                    <th class='GridViewHeaderStyle' style="width:30px;"> S/No.</th>
                    <th class='GridViewHeaderStyle' style="text-align:left" >Category</th>
                    <th class='GridViewHeaderStyle' style="width:90px;" >
                        <input id="chkExcludeCatAll" onchange="checkAll(this.checked,3)" type="checkbox" />Exclude</th>
                     <th class='GridViewHeaderStyle' style="display:none">data</th>
                 </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=ExcludeCategories.length;
		window.status="Total Records Found :"+ dataLength;
		var objExcCatRow;
		var status;
		for(var j=0;j<dataLength;j++)
		{
		objExcCatRow = ExcludeCategories[j];
		#>
		    <tr  onmouseover="this.style.color='#00F'"  onMouseOut="this.style.color=''" id="<#=j+1#>" style='cursor:pointer; background-color:white;'>
                    <td id="tdExcCatIndex" class="GridViewLabItemStyle" style="text-align:center;"><#=j+1#></td>
				    <td id="tdExcCatCategoryName" class="GridViewLabItemStyle"  data-title="Double Click for Sub-Categorywise Setup " ondblclick="bindSubCategoryWiseReferralWiseDoctorShareGrid('<#=objExcCatRow.CategoryID#>','<#=objExcCatRow.CategoryName#>',this,function(){});" style="text-align:left;"><#=objExcCatRow.CategoryName#></td>
					<td id="tdExcludeCat" class="GridViewLabItemStyle" style="text-align:center">
                       <input id="chkExcludeCat" class="chkExcludeCat" type="checkbox" onchange="validateSelection(this)"
						 <#if( objExcCatRow.IsExclude==1){ #>
					         checked="checked"
					    <#}#> /> 
					</td>
                    <td id="tdExcCatData" class="GridViewLabItemStyle" style="text-align:center;display:none"><#= JSON.stringify(objExcCatRow) #></td>          
			</tr>   
        <#}#>
        </tbody>
    </table>
	</script>
    <script id="templateExcludeSubCategory" type="text/html">
     <table class="GridViewStyle FixedTables" cellspacing="0" width="100%" rules="all" border="1" id="tblExcSubCategoryWise" style="width:100%;border-collapse:collapse;">
		<#if(ExcludeSubCategories.length>0){#>

		<thead>
                <tr>
                    <th class='GridViewHeaderStyle' style="width:30px;"> S/No.</th>
                    <th class='GridViewHeaderStyle' style="text-align:left"  >Sub-Category</th>
                    <th class='GridViewHeaderStyle' style="width:90px;" >
                        <input id="chkExcludeSubCatAll" onchange="checkAll(this.checked,4)" type="checkbox" />Exclude</th>
                     <th class='GridViewHeaderStyle' style="display:none">data</th>
                 </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=ExcludeSubCategories.length;
		window.status="Total Records Found :"+ dataLength;
		var objExcSubCatRow;
		var status;
		for(var a=0;a<dataLength;a++)
		{
		objExcSubCatRow = ExcludeSubCategories[a];
		#>
		    <tr  onmouseover="this.style.color='#00F'"  onMouseOut="this.style.color=''" id="<#=a+1#>" style='cursor:pointer; background-color:white;'>
                    <td id="tdExcSubCatIndex" class="GridViewLabItemStyle" style="text-align:center;"><#=a+1#></td>
				    <td id="tdExcSubCatCategoryName" class="GridViewLabItemStyle"  data-title="Double Click for Item wise Setup " ondblclick="bindItemWiseReferralWiseDoctorShareGrid('<#=objExcSubCatRow.CategoryID#>','<#=objExcSubCatRow.SubCategoryID#>','<#=objExcSubCatRow.CategoryName#>',this,function(){});" style="text-align:left;"><#=objExcSubCatRow.CategoryName#></td>
					<td id="tdExcludeSubCat" class="GridViewLabItemStyle" style="text-align:center">
                       <input id="chkExcludeSubCat" class="chkExcludeSubCat" type="checkbox" onchange="validateSelection(this)"
						 <#if( objExcSubCatRow.IsExclude==1){ #>
					         checked="checked"
					    <#}#> /> 
					</td>
                    <td id="tdExcSubCatData" class="GridViewLabItemStyle" style="text-align:center;display:none"><#= JSON.stringify(objExcSubCatRow) #></td>          
			</tr>   
        <#}#>
        </tbody>
    </table>
	</script>

    <script id="templateExcludeItem" type="text/html">

     <table class="GridViewStyle FixedTables" cellspacing="0" width="100%" rules="all" border="1" id="tblExcItemWise" style="width:100%;border-collapse:collapse;">
		<#if(ExcludeItem.length>0){#>

		<thead>
                <tr>
                    <th class='GridViewHeaderStyle' style="width:30px;"> S/No.</th>
                    <th class='GridViewHeaderStyle' style="text-align:left" >Item Name</th>
                    <th class='GridViewHeaderStyle' style="width:90px;" >
                        <input id="chkExcludeItemAll" onchange="checkAll(this.checked,5)" type="checkbox" />Exclude</th>
                     <th class='GridViewHeaderStyle' style="display:none">data</th>
                 </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=ExcludeItem.length;
		window.status="Total Records Found :"+ dataLength;
		var objExcItemRow;
		var status;
		for(var b=0;b<dataLength;b++)
		{
		objExcItemRow = ExcludeItem[b];
		#>
		    <tr  onmouseover="this.style.color='#00F'"  onMouseOut="this.style.color=''" id="<#=b+1#>" style='cursor:pointer; background-color:white;'>
                    <td id="tdExcItemIndex" class="GridViewLabItemStyle" style="text-align:center;"><#=b+1#></td>
				    <td id="tdExcItemName" class="GridViewLabItemStyle" style="text-align:left;"><#=objExcItemRow.CategoryName#></td>
					<td id="tdExcludeItem" class="GridViewLabItemStyle" style="text-align:center">
                       <input id="chkExcludeItem" class="chkExcludeItem" type="checkbox"
						 <#if( objExcItemRow.IsExclude==1){ #>
					         checked="checked"
					    <#}#> /> 
					</td>
                    <td id="tdExcItemData" class="GridViewLabItemStyle" style="text-align:center;display:none"><#= JSON.stringify(objExcItemRow) #></td>          
			</tr>   
        <#}#>
        </tbody>
    </table>
	</script>
    
 <script id="templateCategoryWiseReferralWiseDoctorShare" type="text/html">
	<table class="GridViewStyle FixedTables" cellspacing="0" width="100%" rules="all" border="1" id="tblCategoryWise" style="width:100%;border-collapse:collapse;">
		<#if(CategoryData.length>0){#>

		<thead>
                <tr>
                    <th class='GridViewHeaderStyle' rowspan="2" style="width:60px; text-align:left" >
                      &nbsp;<input id="chkCatAll" onchange="checkAll(this.checked,0)" type="checkbox" />#
                    </th>
                    <th class='GridViewHeaderStyle' rowspan="2" style="width:200px;" > 
                        <# if(CategoryData[0].ServiceType=="3"){#>
                        Doctor Charges
                        <#}
                        else {#>
                        Category
                        <#}#>
                    </th>
                    <th class='GridViewHeaderStyle' rowspan="2" style="width:100px;">Referral Type</th>
                    <th class='GridViewHeaderStyle' colspan="4" style="text-align:center">OPD</th>
                    <th class='GridViewHeaderStyle' colspan="4" style="text-align:center">IPD</th>
                    <th class='GridViewHeaderStyle' colspan="4" style="text-align:center">EMG</th>
                     <th class='GridViewHeaderStyle' rowspan="2" style="display:none">data</th>
                 </tr>
                 <tr>
                    <th class='GridViewHeaderStyle'>(%)</th>
                    <th class='GridViewHeaderStyle'>Amt.</th>
                    <th class='GridViewHeaderStyle'>Bonus(%)</th>
                    <th class='GridViewHeaderStyle' style="width:85px;" >Bonus Amt</th>
                    <th class='GridViewHeaderStyle'>(%)</th>
                    <th class='GridViewHeaderStyle'>Amt.</th>
                    <th class='GridViewHeaderStyle'>Bonus(%)</th>
                    <th class='GridViewHeaderStyle' style="width:85px;">Bonus Amt</th>
                    <th class='GridViewHeaderStyle'>(%)</th>
                    <th class='GridViewHeaderStyle'>Amt.</th>
                    <th class='GridViewHeaderStyle'>Bonus(%)</th>
                    <th class='GridViewHeaderStyle' style="width:85px;">Bonus Amt</th>
			    </tr>

                <tr>
                    <#
                         ReferralType = DoctorSharePageChache.filter(function (i) { return i.TypeID == 4 });
                         ReferralTypeLen= ReferralType.length;
                     #>
                    <th class="GridViewHeaderStyle" colspan="3" style="text-align:left;"> 
                        <div style="display:none;">
                        <#
                          for(var i=0;i<ReferralTypeLen;i++)
                           {
                              objReferralType=ReferralType[i];
                           #>
                           <input type="checkbox" id="chk_Cat_<#=i#>" name="chkCatReferralType" value="<#=objReferralType.ValueField#>" /><#=objReferralType.TextField#>
                         <#}#>
                    </div>
                    </th>
                    
                    <th class="GridViewHeaderStyle" style="text-align:center;"><input type="text" id="txtCatAllOPDSharePer" onkeyup="AllShareChange(this,'CatOPDSharePer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
		        	<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtCatAllOPDShareAmt"  onkeyup="AllShareChange(this,'CatOPDShareAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtCatAllOPDBonusPer" onkeyup="AllShareChange(this,'CatOPDBonusPer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center;"><input type="text" id="txtCatAllOPDBonusAmt" onkeyup="AllShareChange(this,'CatOPDBonusAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
                    <th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtCatAllIPDSharePer" onkeyup="AllShareChange(this,'CatIPDSharePer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtCatAllIPDShareAmt" onkeyup="AllShareChange(this,'CatIPDShareAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtCatAllIPDBonusPer" onkeyup="AllShareChange(this,'CatIPDBonusPer')" onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum'  /></th>
					<th class="GridViewHeaderStyle" style="text-align:center;"><input type="text" id="txtCatAllIPDBonusAmt" onkeyup="AllShareChange(this,'CatIPDBonusAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
                    <th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtCatAllEMGSharePer" onkeyup="AllShareChange(this,'CatEMGSharePer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtCatAllEMGShareAmt" onkeyup="AllShareChange(this,'CatEMGShareAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtCatAllEMGBonusPer" onkeyup="AllShareChange(this,'CatEMGBonusPer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center;"><input type="text" id="txtCatAllEMGBonusAmt" onkeyup="AllShareChange(this,'CatEMGBonusAmt')" onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
                     
			    </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=CategoryData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRowCat;   
		for(var k=0;k<dataLength;k++)
		{

		objRowCat = CategoryData[k];  
		
		  #>
						<tr  onmouseover="this.style.color='#00F'"  onMouseOut="this.style.color=''" id="<#=k+1#>" style='cursor:pointer; background-color:white;'>
						<td id="tdCatIndex" class="GridViewLabItemStyle" style="text-align:left">
                             &nbsp;<input id="chkCat" class="chkCat" type="checkbox"
						    <#if( objRowCat.IsAlreadySet==1){ #>
							 checked="checked"
							<#}#>   /> 
                            <#=k+1#>.
						</td>
                        
                        <# if(k>0) { if(CategoryData[k].MergeBy !=CategoryData[k-1].MergeBy){#> <td id="tdCatCategoryName" <# if(CategoryData[0].ServiceType=="1"){#> ondblclick="bindSubCategoryWiseReferralWiseDoctorShareGrid('<#=objRowCat.CategoryID#>','<#=objRowCat.CategoryName#>',this,function(){});" data-title="Double Click for Sub-Categorywise Share Setup " <#}#>  rowspan='<#=ReferralTypeLen#>' class="GridViewLabItemStyle" style="text-align:left; font-weight:bold;"><#=objRowCat.CategoryName#>  </td> <#}} else {#> <td id="tdCatCategoryName" rowspan='<#=ReferralTypeLen#>' <# if(CategoryData[0].ServiceType=="1"){#> ondblclick="bindSubCategoryWiseReferralWiseDoctorShareGrid('<#=objRowCat.CategoryID#>','<#=objRowCat.CategoryName#>',this,function(){});" data-title="Double Click for Sub-Categorywise Share Setup" <#}#>  class="GridViewLabItemStyle" style="text-align:left; font-weight:bold;"><#=objRowCat.CategoryName#>  </td> <#} #>
                       
						<td id="tdCatReferralType" class="GridViewLabItemStyle" style="text-align:center;"><#=objRowCat.ReferralType#></td>
						<td id="tdCatOPDSharePer" class="GridViewLabItemStyle" style="text-align:center;"><input type="text" class="CatOPDSharePer ItDoseTextinputNum" id="txtCatOPDSharePer" onkeyup ="ValidateValues(this);"  value='<#=objRowCat.OPDSharePer#>' onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdCatOPDShareAmt" class="GridViewLabItemStyle" style="text-align:center"><input type="text"  class="CatOPDShareAmt ItDoseTextinputNum" id="txtCatOPDShareAmt" onkeyup="ValidateValues(this);" value='<#=objRowCat.OPDShareAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdCatOPDBonusPer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="CatOPDBonusPer ItDoseTextinputNum" id="txtCatOPDBonusPer" onkeyup="ValidateValues(this);" value='<#=objRowCat.OPDBonusPer#>'  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdCatOPDBonusAmt" class="GridViewLabItemStyle" style="text-align:center;"><input type="text" class="CatOPDBonusAmt ItDoseTextinputNum" id="txtCatOPDBonusAmt" onkeyup="ValidateValues(this);" value='<#=objRowCat.OPDBonusAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
                        <td id="tdCatIPDSharePer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="CatIPDSharePer ItDoseTextinputNum" id="txtCatIPDSharePer" onkeyup ="ValidateValues(this);" value='<#=objRowCat.IPDSharePer#>'  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdCatIPDShareAmt" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="CatIPDShareAmt ItDoseTextinputNum" id="txtCatIPDShareAmt" onkeyup ="ValidateValues(this);" value='<#=objRowCat.IPDShareAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdCatIPDBonusPer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="CatIPDBonusPer ItDoseTextinputNum" id="txtCatIPDBonusPer" onkeyup ="ValidateValues(this);" value='<#=objRowCat.IPDBonusPer#>' onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdCatIPDBonusAmt" class="GridViewLabItemStyle" style="text-align:center;"><input type="text" class="CatIPDBonusAmt ItDoseTextinputNum" id="txtCatIPDBonusAmt" onkeyup ="ValidateValues(this);" value='<#=objRowCat.IPDBonusAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
                        <td id="tdCatEMGSharePer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="CatEMGSharePer ItDoseTextinputNum" id="txtCatEMGSharePer" onkeyup ="ValidateValues(this);" value='<#=objRowCat.EMGSharePer#>'  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdCatEMGShareAmt" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="CatEMGShareAmt ItDoseTextinputNum" id="txtCatEMGShareAmt" onkeyup ="ValidateValues(this);" value='<#=objRowCat.EMGShareAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdCatEMGBonusPer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="CatEMGBonusPer ItDoseTextinputNum" id="txtCatEMGBonusPer" onkeyup ="ValidateValues(this);" value='<#=objRowCat.EMGBonusPer#>'  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdCatEMGBonusAmt" class="GridViewLabItemStyle" style="text-align:center;"><input type="text" class="CatEMGBonusAmt ItDoseTextinputNum" id="txtCatEMGBonusAmt" onkeyup ="ValidateValues(this);" value='<#=objRowCat.EMGBonusAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
                       
                             <td id="tdCatRowData" class="GridViewLabItemStyle" style="text-align:center;display:none"><#= JSON.stringify(objRowCat)  #></td>          
						</tr>   

			<#}#>
        </tbody>
	 </table>    
	</script>
    <script id="templateSubCategoryWiseReferralWiseDoctorShare" type="text/html">
	<table class="GridViewStyle FixedTables" cellspacing="0" width="100%" rules="all" border="1" id="tblSubCategoryWise" style="width:100%;border-collapse:collapse;">
		<#if(SubCategoryData.length>0){#>

		<thead>
                <tr>
                    <th class='GridViewHeaderStyle' rowspan="2" style="width:65px; text-align:left" >
                      &nbsp;<input id="chkSubCatAll" onchange="checkAll(this.checked,1)" type="checkbox" />#
                    </th>
                    <th class='GridViewHeaderStyle' rowspan="2" style="width:200px;" >Sub-Category</th>
                    <th class='GridViewHeaderStyle' rowspan="2" style="width:100px;">Referral Type</th>
                    <th class='GridViewHeaderStyle' colspan="4" style="text-align:center">OPD</th>
                    <th class='GridViewHeaderStyle' colspan="4" style="text-align:center">IPD</th>
                    <th class='GridViewHeaderStyle' colspan="4" style="text-align:center">EMG</th>
                     <th class='GridViewHeaderStyle' rowspan="2" style="display:none">data</th>
                 </tr>
                 <tr>
                    <th class='GridViewHeaderStyle'>(%)</th>
                    <th class='GridViewHeaderStyle'>Amt.</th>
                    <th class='GridViewHeaderStyle'>Bonus(%)</th>
                    <th class='GridViewHeaderStyle' style="width:85px;" >Bonus Amt</th>
                    <th class='GridViewHeaderStyle'>(%)</th>
                    <th class='GridViewHeaderStyle'>Amt.</th>
                    <th class='GridViewHeaderStyle'>Bonus(%)</th>
                    <th class='GridViewHeaderStyle' style="width:85px;">Bonus Amt</th>
                    <th class='GridViewHeaderStyle'>(%)</th>
                    <th class='GridViewHeaderStyle'>Amt.</th>
                    <th class='GridViewHeaderStyle'>Bonus(%)</th>
                    <th class='GridViewHeaderStyle' style="width:85px;">Bonus Amt</th>
			    </tr>

                <tr>
                    <#
                         ReferralType = DoctorSharePageChache.filter(function (i) { return i.TypeID == 4 });
                         ReferralTypeLen= ReferralType.length;
                     #>
                    <th class="GridViewHeaderStyle" colspan="3" style="text-align:left;"> 
                        <div style="display:none;">
                        <#
                          for(var i=0;i<ReferralTypeLen;i++)
                           {
                              objReferralType=ReferralType[i];
                           #>
                           <input type="checkbox" id="chk_SubCat_<#=i#>" name="chkSubCatReferralType" value="<#=objReferralType.ValueField#>" /><#=objReferralType.TextField#>
                         <#}#>
                    </div>
                    </th>
                    
                     <th class="GridViewHeaderStyle" style="text-align:center;"><input type="text" id="txtSubCatAllOPDSharePer" onkeyup="AllShareChange(this,'SubCatOPDSharePer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
		        	<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtSubCatAllOPDShareAmt"  onkeyup="AllShareChange(this,'SubCatOPDShareAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtSubCatAllOPDBonusPer" onkeyup="AllShareChange(this,'SubCatOPDBonusPer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center;"><input type="text" id="txtSubCatAllOPDBonusAmt" onkeyup="AllShareChange(this,'SubCatOPDBonusAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
                    <th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtSubCatAllIPDSharePer" onkeyup="AllShareChange(this,'SubCatIPDSharePer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtSubCatAllIPDShareAmt" onkeyup="AllShareChange(this,'SubCatIPDShareAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtSubCatAllIPDBonusPer" onkeyup="AllShareChange(this,'SubCatIPDBonusPer')" onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum'  /></th>
					<th class="GridViewHeaderStyle" style="text-align:center;"><input type="text" id="txtSubCatAllIPDBonusAmt" onkeyup="AllShareChange(this,'SubCatIPDBonusAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
                    <th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtSubCatAllEMGSharePer" onkeyup="AllShareChange(this,'SubCatEMGSharePer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtSubCatAllEMGShareAmt" onkeyup="AllShareChange(this,'SubCatEMGShareAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtSubCatAllEMGBonusPer" onkeyup="AllShareChange(this,'SubCatEMGBonusPer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center;"><input type="text" id="txtSubCatAllEMGBonusAmt" onkeyup="AllShareChange(this,'SubCatEMGBonusAmt')" onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
                      
			    </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=SubCategoryData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRowSubCat;   
		for(var l=0;l<dataLength;l++)
		{

		objRowSubCat = SubCategoryData[l];
		
		  #>
						<tr  onmouseover="this.style.color='#00F'"  onMouseOut="this.style.color=''" id="<#=l+1#>" style='cursor:pointer; background-color:white;'>
						<td id="tdSubCatIndex" class="GridViewLabItemStyle" style="text-align:left">
                            &nbsp;<input id="chkSubCat" class="chkSubCat" type="checkbox"
						    <#if( objRowSubCat.IsAlreadySet==1){ #>
							 checked="checked"
							<#}#>   /> 
                            <#=l+1#>.</td>
                        
                        <# if(l>0) { if(SubCategoryData[l].MergeBy !=SubCategoryData[l-1].MergeBy){#> <td id="tdSubCatCategoryName" <# if(SubCategoryData[0].ServiceType=="1"){#> ondblclick="bindItemWiseReferralWiseDoctorShareGrid('<#=objRowSubCat.CategoryID#>','<#=objRowSubCat.SubCategoryID#>','<#=objRowSubCat.CategoryName#>',this,function(){});"  data-title="Double Click for Item-Wise Share Setup " <#}#>  rowspan='<#=ReferralTypeLen#>' class="GridViewLabItemStyle" style="text-align:left; font-weight:bold;"><#=objRowSubCat.CategoryName#>  </td> <#}} else {#> <td id="tdSubCatCategoryName" rowspan='<#=ReferralTypeLen#>' <# if(SubCategoryData[0].ServiceType=="1"){#> ondblclick="bindItemWiseReferralWiseDoctorShareGrid('<#=objRowSubCat.CategoryID#>','<#=objRowSubCat.SubCategoryID#>','<#=objRowSubCat.CategoryName#>',this,function(){});"  data-title="Double Click for Item-Wise Share Setup" <#}#>  class="GridViewLabItemStyle" style="text-align:left; font-weight:bold;"><#=objRowSubCat.CategoryName#>  </td> <#} #>
                       
						<td id="tdSubCatReferralType" class="GridViewLabItemStyle" style="text-align:center;"><#=objRowSubCat.ReferralType#></td>
						<td id="tdSubCatOPDSharePer" class="GridViewLabItemStyle" style="text-align:center;"><input type="text" class="SubCatOPDSharePer ItDoseTextinputNum" id="txtSubCatOPDSharePer" onkeyup ="ValidateValues(this);"  value='<#=objRowSubCat.OPDSharePer#>' onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdSubCatOPDShareAmt" class="GridViewLabItemStyle" style="text-align:center"><input type="text"  class="SubCatOPDShareAmt ItDoseTextinputNum" id="txtSubCatOPDShareAmt" onkeyup ="ValidateValues(this);" value='<#=objRowSubCat.OPDShareAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdSubCatOPDBonusPer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="SubCatOPDBonusPer ItDoseTextinputNum" id="txtSubCatOPDBonusPer" onkeyup ="ValidateValues(this);" value='<#=objRowSubCat.OPDBonusPer#>'  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdSubCatOPDBonusAmt" class="GridViewLabItemStyle" style="text-align:center;"><input type="text" class="SubCatOPDBonusAmt ItDoseTextinputNum" id="txtSubCatOPDBonusAmt" onkeyup ="ValidateValues(this);" value='<#=objRowSubCat.OPDBonusAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
                        <td id="tdSubCatIPDSharePer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="SubCatIPDSharePer ItDoseTextinputNum" id="txtSubCatIPDSharePer" onkeyup ="ValidateValues(this);" value='<#=objRowSubCat.IPDSharePer#>'  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdSubCatIPDShareAmt" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="SubCatIPDShareAmt ItDoseTextinputNum" id="txtSubCatIPDShareAmt" onkeyup ="ValidateValues(this);" value='<#=objRowSubCat.IPDShareAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdSubCatIPDBonusPer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="SubCatIPDBonusPer ItDoseTextinputNum" id="txtSubCatIPDBonusPer" onkeyup ="ValidateValues(this);" value='<#=objRowSubCat.IPDBonusPer#>' onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdSubCatIPDBonusAmt" class="GridViewLabItemStyle" style="text-align:center;"><input type="text" class="SubCatIPDBonusAmt ItDoseTextinputNum" id="txtSubCatIPDBonusAmt" onkeyup ="ValidateValues(this);" value='<#=objRowSubCat.IPDBonusAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
                        <td id="tdSubCatEMGSharePer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="SubCatEMGSharePer ItDoseTextinputNum" id="txtSubCatEMGSharePer" onkeyup ="ValidateValues(this);" value='<#=objRowSubCat.EMGSharePer#>'  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdSubCatEMGShareAmt" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="SubCatEMGShareAmt ItDoseTextinputNum" id="txtSubCatEMGShareAmt" onkeyup ="ValidateValues(this);" value='<#=objRowSubCat.EMGShareAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdSubCatEMGBonusPer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="SubCatEMGBonusPer ItDoseTextinputNum" id="txtSubCatEMGBonusPer" onkeyup ="ValidateValues(this);" value='<#=objRowSubCat.EMGBonusPer#>'  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdSubCatEMGBonusAmt" class="GridViewLabItemStyle" style="text-align:center;"><input type="text" class="SubCatEMGBonusAmt ItDoseTextinputNum" id="txtSubCatEMGBonusAmt" onkeyup ="ValidateValues(this);" value='<#=objRowSubCat.EMGBonusAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
                        <td id="tdSubCatRowData" class="GridViewLabItemStyle" style="text-align:center;display:none"><#= JSON.stringify(objRowSubCat)  #></td>          
						</tr>   

			<#}#>
        </tbody>
	 </table>    
	</script>




    <script id="templateItemWiseReferralWiseDoctorShare" type="text/html">
	<table class="GridViewStyle FixedTables" cellspacing="0" width="100%" rules="all" border="1" id="tblItemWise" style="width:100%;border-collapse:collapse;">
		<#if(ItemData.length>0){#>

		<thead>
                <tr>
                    <th class='GridViewHeaderStyle' rowspan="2" style="width:75px; text-align:left" >
                     &nbsp;<input id="chkItemAll" onchange="checkAll(this.checked,2)" type="checkbox" />#</th>
                    <th class='GridViewHeaderStyle' rowspan="2" style="width:200px;" >Item Name</th>
                    <th class='GridViewHeaderStyle' rowspan="2" style="width:100px;">Referral Type</th>
                    <th class='GridViewHeaderStyle' colspan="4" style="text-align:center">OPD</th>
                    <th class='GridViewHeaderStyle' colspan="4" style="text-align:center">IPD</th>
                    <th class='GridViewHeaderStyle' colspan="4" style="text-align:center">EMG</th>
                     <th class='GridViewHeaderStyle' rowspan="2" style="display:none">data</th>
                 </tr>
                 <tr>
                    <th class='GridViewHeaderStyle'>(%)</th>
                    <th class='GridViewHeaderStyle'>Amt.</th>
                    <th class='GridViewHeaderStyle'>Bonus(%)</th>
                    <th class='GridViewHeaderStyle' style="width:85px;" >Bonus Amt</th>
                    <th class='GridViewHeaderStyle'>(%)</th>
                    <th class='GridViewHeaderStyle'>Amt.</th>
                    <th class='GridViewHeaderStyle'>Bonus(%)</th>
                    <th class='GridViewHeaderStyle' style="width:85px;">Bonus Amt</th>
                    <th class='GridViewHeaderStyle'>(%)</th>
                    <th class='GridViewHeaderStyle'>Amt.</th>
                    <th class='GridViewHeaderStyle'>Bonus(%)</th>
                    <th class='GridViewHeaderStyle' style="width:85px;">Bonus Amt</th>
			    </tr>

                <tr>
                    <#
                         ReferralType = DoctorSharePageChache.filter(function (i) { return i.TypeID == 4 });
                         ReferralTypeLen= ReferralType.length;
                     #>
                    <th class="GridViewHeaderStyle" colspan="3" style="text-align:left;"> 
                        <div style="display:none;">
                        <#
                          for(var i=0;i<ReferralTypeLen;i++)
                           {
                              objReferralType=ReferralType[i];
                           #>
                           <input type="checkbox" id="chk_Item_<#=i#>" name="chkItemReferralType" value="<#=objReferralType.ValueField#>" /><#=objReferralType.TextField#>

                         <#}#>
                    </div>
                    </th>
                    <th class="GridViewHeaderStyle" style="text-align:center;"><input type="text" id="txtItemAllOPDSharePer" onkeyup="AllShareChange(this,'ItemOPDSharePer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
		        	<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtItemAllOPDShareAmt"  onkeyup="AllShareChange(this,'ItemOPDShareAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtItemAllOPDBonusPer" onkeyup="AllShareChange(this,'ItemOPDBonusPer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center;"><input type="text" id="txtItemAllOPDBonusAmt" onkeyup="AllShareChange(this,'ItemOPDBonusAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
                    <th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtItemAllIPDSharePer" onkeyup="AllShareChange(this,'ItemIPDSharePer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtItemAllIPDShareAmt" onkeyup="AllShareChange(this,'ItemIPDShareAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtItemAllIPDBonusPer" onkeyup="AllShareChange(this,'ItemIPDBonusPer')" onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum'  /></th>
					<th class="GridViewHeaderStyle" style="text-align:center;"><input type="text" id="txtItemAllIPDBonusAmt" onkeyup="AllShareChange(this,'ItemIPDBonusAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
                    <th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtItemAllEMGSharePer" onkeyup="AllShareChange(this,'ItemEMGSharePer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtItemAllEMGShareAmt" onkeyup="AllShareChange(this,'ItemEMGShareAmt')"  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center"><input type="text" id="txtItemAllEMGBonusPer" onkeyup="AllShareChange(this,'ItemEMGBonusPer')"  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
					<th class="GridViewHeaderStyle" style="text-align:center;"><input type="text" id="txtItemAllEMGBonusAmt" onkeyup="AllShareChange(this,'ItemEMGBonusAmt')" onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' class='ItDoseTextinputNum' /></th>
                     
			    </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=ItemData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRowItem;   
		for(var m=0;m<dataLength;m++)
		{

		objRowItem = ItemData[m];
		
		  #>
					<tr  onmouseover="this.style.color='#00F'"  onMouseOut="this.style.color=''" id="<#=m+1#>" style='cursor:pointer; background-color:white;'>
						<td id="tdItemIndex" class="GridViewLabItemStyle" style="text-align:left">
                            &nbsp;<input id="chkItem" class="chkItem" type="checkbox"
						    <#if( objRowItem.IsAlreadySet==1){ #>
							 checked="checked"
							<#}#>   /> 
                            <#=m+1#>.</td>
                        
                        <# if(m>0) { if(ItemData[m].MergeBy !=ItemData[m-1].MergeBy){#> <td id="tdItemName"  rowspan='<#=ReferralTypeLen#>' class="GridViewLabItemStyle" style="text-align:left; font-weight:bold;"><#=objRowItem.CategoryName#>  </td> <#}} else {#> <td id="tdItemName" rowspan='<#=ReferralTypeLen#>' class="GridViewLabItemStyle" style="text-align:left; font-weight:bold;"><#=objRowItem.CategoryName#>  </td> <#} #>
                       
						<td id="tdItemReferralType" class="GridViewLabItemStyle" style="text-align:center;"><#=objRowItem.ReferralType#></td>
						<td id="tdItemOPDSharePer" class="GridViewLabItemStyle" style="text-align:center;"><input type="text" class="ItemOPDSharePer ItDoseTextinputNum" id="txtItemOPDSharePer" onkeyup ="ValidateValues(this);"  value='<#=objRowItem.OPDSharePer#>' onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdItemOPDShareAmt" class="GridViewLabItemStyle" style="text-align:center"><input type="text"  class="ItemOPDShareAmt ItDoseTextinputNum" id="txtItemOPDShareAmt" onkeyup ="ValidateValues(this);" value='<#=objRowItem.OPDShareAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdItemOPDBonusPer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="ItemOPDBonusPer ItDoseTextinputNum" id="txtItemOPDBonusPer" onkeyup ="ValidateValues(this);" value='<#=objRowItem.OPDBonusPer#>'  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdItemOPDBonusAmt" class="GridViewLabItemStyle" style="text-align:center;"><input type="text" class="ItemOPDBonusAmt ItDoseTextinputNum" id="txtItemOPDBonusAmt" onkeyup ="ValidateValues(this);" value='<#=objRowItem.OPDBonusAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
                        <td id="tdItemIPDSharePer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="ItemIPDSharePer ItDoseTextinputNum" id="txtItemIPDSharePer" onkeyup ="ValidateValues(this);" value='<#=objRowItem.IPDSharePer#>'  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdItemIPDShareAmt" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="ItemIPDShareAmt ItDoseTextinputNum" id="txtItemIPDShareAmt" onkeyup ="ValidateValues(this);" value='<#=objRowItem.IPDShareAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdItemIPDBonusPer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="ItemIPDBonusPer ItDoseTextinputNum" id="txtItemIPDBonusPer" onkeyup ="ValidateValues(this);" value='<#=objRowItem.IPDBonusPer#>' onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdItemIPDBonusAmt" class="GridViewLabItemStyle" style="text-align:center;"><input type="text" class="ItemIPDBonusAmt ItDoseTextinputNum" id="txtItemIPDBonusAmt" onkeyup ="ValidateValues(this);" value='<#=objRowItem.IPDBonusAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
                        <td id="tdItemEMGSharePer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="ItemEMGSharePer ItDoseTextinputNum" id="txtItemEMGSharePer" onkeyup ="ValidateValues(this);" value='<#=objRowItem.EMGSharePer#>'  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdItemEMGShareAmt" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="ItemEMGShareAmt ItDoseTextinputNum" id="txtItemEMGShareAmt" onkeyup ="ValidateValues(this);" value='<#=objRowItem.EMGShareAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdItemEMGBonusPer" class="GridViewLabItemStyle" style="text-align:center"><input type="text" class="ItemEMGBonusPer ItDoseTextinputNum" id="txtItemEMGBonusPer" onkeyup ="ValidateValues(this);" value='<#=objRowItem.EMGBonusPer#>'  onlynumber='14'  decimalplace='2'  max-value='100'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
						<td id="tdItemEMGBonusAmt" class="GridViewLabItemStyle" style="text-align:center;"><input type="text" class="ItemEMGBonusAmt ItDoseTextinputNum" id="txtItemEMGBonusAmt" onkeyup ="ValidateValues(this);" value='<#=objRowItem.EMGBonusAmt#>'  onlynumber='14'  decimalplace='2'  max-value='10000000'  autocomplete='off' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' /></td>
                        <td id="tdItemRowData" class="GridViewLabItemStyle" style="text-align:center;display:none"><#= JSON.stringify(objRowItem)  #></td>          
				    </tr>   

			<#}#>
        </tbody>
	 </table>    
	</script>

</asp:Content>
