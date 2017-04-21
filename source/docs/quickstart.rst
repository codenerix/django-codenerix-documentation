Quickstart
==========

1. Install your Linux (we checked it out on Debian 8.7)

2. Make sure you have installed the required packages to work with GIT and Python::

.. code:: console

    apt-get install git python-pip python3-pip

3. Clone the `CODENERIX Examples <https://github.com/centrologic/django-codenerix-examples>`_ project::

.. code:: console

    git clone https://github.com/centrologic/django-codenerix-examples

4. Go to the desired folder (we will go to **agenda**)::

.. code:: console

    cd django-codenerix-examples/agenda/

5. Install all requirements for the choosen example::

.. code:: console

    For python 2: sudo pip2 install -r requirements.txt
    For python 3: sudo pip3 install -r requirements.txt

6. That's all...check it out::

.. code:: console

    In python 2: python2 manage.py runserver
    In python 3: python3 manage.py runserver


Adding code
===========


From here we will be improving the basic example with new models, views, etc...


0. Start and configure
++++++++++++++++++++++

First step it's to create a project and configure its settings.

Follow this guide to set up a project from begin. We assume that you have sucessfully run the Quickstart.

-  Execute the Django command startproject to create a new project named *librarymanager*.

.. code:: console

    django-admin startproject librarymanager


-  Enter in the project folder and start a new app, in this case the app will be a Python package named *library* inside the project root.

.. code:: console

    ./manage.py startapp library


-  Now we have our project and app created. Next step is to configure the project editing the *settings.py* module. Let's add your new app to INSTALLED_APPS.

.. code:: python

    # Installed apps
    INSTALLED_APPS = [
        ...
        'library',   # Our app
        ...
    ]


Following this step, you will have a basic Codenerix project ready to run with your new **'library'** app.


1. Create a model
+++++++++++++++++

.. code:: python

    from codenerix.models import CodenerixModel
    from django.db import models

    class Author(CodenerixModel):
        name = models.CharField(_(u'Name'), max_length=128, blank=False, null=False)
        birth_date = models.CharField(_(u'Fecha de nacimiento'), max_length=128, blank=False, null=False)
        
        def __fields__(self, info):
            fields=[]
            fields.append(('name', _('Name'), 100, 'left'))
            fields.append(('birth_date', _('Birth Date')))
            return fields


    class Book(CodenerixModel):
        name = models.CharField(_(u'Name'), max_length=128, blank=False, null=False)
        author = models.ForeignKey(Author, max_length=128, blank=False, null=False)
        isbn = models.CharField(_(u'ISBN'), max_length=128, blank=False, null=False)

        def __fields__(self,info):
            fields = []
            fields.append(('name', _('Name'), 100, 'left'))
            fields.append(('isbn', _('ISBN')))
            fields.append(('author', _('Author')))
            return fields


The first step to start coding a Django project is create data models. In this case we will make two Models as showed above, Author and Book, both inheriting from the base class :ref:`class-codenerixmodel`. The structure is simple, we declare all fields (as in Django) and then the method __fields__. This method is mandatory because is needed by Codenerix to define which fields are shown and in which order.


2. Create a form
++++++++++++++++

.. code:: python

    from codenerix.forms import GenModelForm

    class BookForm(GenModelForm):
        model = Book
        exclude = []

        def __groups__(self):
            groups = [(_('Book'), 12, ['name', 6], ['isbn', 6], ['author', 3])]
            return groups


        @staticmethod
        def __groups_details__():
            details = [(_('Book'), 12, ['name' , 6], ['isbn', 6], ['author', 3])]
            return details


    class AuthorForm(GenModelForm):
        model = Author
        exclude = []

        def __groups__(self):
            groups = [(_('Author'), 12, ['name', 6], ['birth_date', 6])]
            return groups


        @staticmethod
        def __groups_details__():
            details = [(_('Author'), 12, ['name', 6], ['birth_date', 6])]
            return details


The second step is to create a form. In our example we are creating two forms, one for the Book model and another for the Author model. In addition, both forms have implemented the static method **__groups_details__**. This method is important because we will use them in :ref:`class-gendetail` to layout its representation.


3. Create views
+++++++++++++++

.. code:: python

    from codenerix.views import GenList, GenCreate, GenCreateModal, GenUpdate, GenUpdateModal, GenDelete
    from library.forms import AuthorForm 


    class AuthorList(GenList):
        model = Author
        show_details = True


    class AuthorCreate(GenCreate):
        model = Author
        form_class = AuthorForm


    class AuthorCreateModal(GenCreateModal, AuthorCreate):
        pass


    class AuthorUpdate(GenUpdate):
        model = Author
        form_class = AuthorForm


    class AuthorUpdateModal(GenUpdateModal, AuthorUpdate):
        pass


    class AuthorDelete(GenDelete):
        model = Author


    class AuthorDetails(GenDetail):
        model = Author
        groups = AuthorForm.__groups_details__()


    class AuthorDetailModal(GenDetailModal, AuthorDetails):
        pass


    class BookList(GenList):
        model = Book
        show_details = True


    class BookCreate(GenCreate):
        model = Book
        form_class = BookForm


    class BookCreateModal(GenCreateModal, BookCreate):
        pass


    class BookUpdate(GenUpdate):
        model = Book
        form_class = BookForm


    class BookUpdateModal(GenUpdateModal, BookUpdate):
        pass


    class BookDelete(GenDelete):
        model = Book


    class BookDetails(GenDetail):
        model = Book
        groups = BookForm.__groups_details__()


    class BookDetailModal(GenDetailModal, BookDetails):
        pass


The third step is to create the views. A basic view don't need to associated to any html template, generation will be automatically accomplished by Codenerix.


4. Urls
+++++++

.. code:: python

    from django.conf.urls import url
    from library import views


    urlpatterns = [

        url(r'^book$',views.BookList.as_view(), name='book_list'),
        url(r'^book/add$', views.BookCreate.as_view(), name='book_add'),
        url(r'^book/addmodal$', views.BookCreateModal.as_view(), name='book_addmodal'),
        url(r'^book/(?P<pk>\w+)$', views.BookDetail.as_view(), name='book_detail'),
        url(r'^book/(?P<pk>\w+)/edit$', views.BookUpdate.as_view(), name='book_edit'),
        url(r'^book/(?P<pk>\w+)/editmodal$', views.BookUpdateModal.as_view(), name='book_editmodal'),
        url(r'^book/(?P<pk>\w+)/delete$', views.BookDelete.as_view(), name='book_delete'),


        url(r'^author$', views.AuthorList.as_view(), name='author_list'),
        url(r'^author/add$', views.AuthorCreate.as_view(), name='author_add'),
        url(r'^author/addmodal$', views.AuthorCreateModal.as_view(), name='author_addmodal'),
        url(r'^author/(?P<pk>\w+)$', views.AuthorDetail.as_view(), name='author_detail'),
        url(r'^author/(?P<pk>\w+)/edit$', views.AuthorUpdate.as_view(), name='author_edit'),
        url(r'^author/(?P<pk>\w+)/editmodal$', views.AuthorUpdateModal.as_view(), name='author_editmodal'),
        url(r'^author/(?P<pk>\w+)/delete$', views.AuthorDelete.as_view(), name='author_delete'),

    ]


The last step is to associate the urls with the views using the Django routing system. The example from above shows the prefered naming conventions proposed by Codenerix.

Finally, we have a project ready to be tested using the Django development server.
