PGDMP  2                    }           ehotels    17.2    17.2 $    @           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            A           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            B           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            C           1262    32987    ehotels    DATABASE     i   CREATE DATABASE ehotels WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';
    DROP DATABASE ehotels;
                     postgres    false                        2615    33112    ehotelschema    SCHEMA        CREATE SCHEMA ehotelschema;
    DROP SCHEMA ehotelschema;
                  
   sashamilne    false            �            1255    33240    check_reservation_dates()    FUNCTION       CREATE FUNCTION public.check_reservation_dates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.date_de_fin <= NEW.date_de_debut THEN
        RAISE EXCEPTION 'La date de fin doit être postérieure à la date de début.';
    END IF;
    RETURN NEW;
END;
$$;
 0   DROP FUNCTION public.check_reservation_dates();
       public               postgres    false            �            1255    33238    update_registration_date()    FUNCTION     �   CREATE FUNCTION public.update_registration_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.date_enregistrement = CURRENT_DATE;
    RETURN NEW;
END;
$$;
 1   DROP FUNCTION public.update_registration_date();
       public               postgres    false            �            1259    33113    client    TABLE       CREATE TABLE ehotelschema.client (
    sin integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    registration_date date NOT NULL,
    phone_number character varying(20) NOT NULL,
    email character varying(50) NOT NULL
);
     DROP TABLE ehotelschema.client;
       ehotelschema         heap r    
   sashamilne    false    6            �            1259    33116    employee    TABLE     &  CREATE TABLE ehotelschema.employee (
    sin integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    employee_role character varying(50),
    works_at integer,
    email character varying(50),
    phone_number character varying(20)
);
 "   DROP TABLE ehotelschema.employee;
       ehotelschema         heap r    
   sashamilne    false    6            �            1259    33119    hotel    TABLE     *  CREATE TABLE ehotelschema.hotel (
    hotel_id integer NOT NULL,
    chain_id integer NOT NULL,
    hotel_address character varying(100) NOT NULL,
    phone_number character varying(20) NOT NULL,
    email character varying(50) NOT NULL,
    rating numeric(2,1) NOT NULL,
    manager_id integer
);
    DROP TABLE ehotelschema.hotel;
       ehotelschema         heap r    
   sashamilne    false    6            �            1259    33122    hotel_chain    TABLE       CREATE TABLE ehotelschema.hotel_chain (
    chain_id integer NOT NULL,
    office_address character varying(100) NOT NULL,
    chain_name character varying(100) NOT NULL,
    phone_number character varying(20) NOT NULL,
    email character varying(50) NOT NULL
);
 %   DROP TABLE ehotelschema.hotel_chain;
       ehotelschema         heap r    
   sashamilne    false    6            �            1259    33125    reservation    TABLE     �   CREATE TABLE ehotelschema.reservation (
    reservation_id integer NOT NULL,
    room_number integer NOT NULL,
    sin integer NOT NULL,
    check_in_date date NOT NULL,
    check_out_date date NOT NULL,
    reservation_date date NOT NULL
);
 %   DROP TABLE ehotelschema.reservation;
       ehotelschema         heap r    
   sashamilne    false    6            �            1259    33128    room    TABLE     �   CREATE TABLE ehotelschema.room (
    room_number integer NOT NULL,
    hotel_id integer NOT NULL,
    room_type character varying(50) NOT NULL,
    price numeric(6,2) NOT NULL
);
    DROP TABLE ehotelschema.room;
       ehotelschema         heap r    
   sashamilne    false    6            8          0    33113    client 
   TABLE DATA                 ehotelschema            
   sashamilne    false    218   S-       9          0    33116    employee 
   TABLE DATA                 ehotelschema            
   sashamilne    false    219   �-       :          0    33119    hotel 
   TABLE DATA                 ehotelschema            
   sashamilne    false    220   O.       ;          0    33122    hotel_chain 
   TABLE DATA                 ehotelschema            
   sashamilne    false    221   �6       <          0    33125    reservation 
   TABLE DATA                 ehotelschema            
   sashamilne    false    222   �7       =          0    33128    room 
   TABLE DATA                 ehotelschema            
   sashamilne    false    223   �7       �           2606    33132    client client_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY ehotelschema.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (sin);
 B   ALTER TABLE ONLY ehotelschema.client DROP CONSTRAINT client_pkey;
       ehotelschema              
   sashamilne    false    218            �           2606    33134    employee employee_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY ehotelschema.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (sin);
 F   ALTER TABLE ONLY ehotelschema.employee DROP CONSTRAINT employee_pkey;
       ehotelschema              
   sashamilne    false    219            �           2606    33136    hotel_chain hotel_chain_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY ehotelschema.hotel_chain
    ADD CONSTRAINT hotel_chain_pkey PRIMARY KEY (chain_id);
 L   ALTER TABLE ONLY ehotelschema.hotel_chain DROP CONSTRAINT hotel_chain_pkey;
       ehotelschema              
   sashamilne    false    221            �           2606    33138    hotel hotel_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY ehotelschema.hotel
    ADD CONSTRAINT hotel_pkey PRIMARY KEY (hotel_id);
 @   ALTER TABLE ONLY ehotelschema.hotel DROP CONSTRAINT hotel_pkey;
       ehotelschema              
   sashamilne    false    220            �           2606    33140    reservation reservation_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY ehotelschema.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (reservation_id);
 L   ALTER TABLE ONLY ehotelschema.reservation DROP CONSTRAINT reservation_pkey;
       ehotelschema              
   sashamilne    false    222            �           2606    33142    room room_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY ehotelschema.room
    ADD CONSTRAINT room_pkey PRIMARY KEY (room_number);
 >   ALTER TABLE ONLY ehotelschema.room DROP CONSTRAINT room_pkey;
       ehotelschema              
   sashamilne    false    223            �           1259    33243    idx_check_in_date    INDEX     X   CREATE INDEX idx_check_in_date ON ehotelschema.reservation USING btree (check_in_date);
 +   DROP INDEX ehotelschema.idx_check_in_date;
       ehotelschema              
   sashamilne    false    222            �           1259    33244    idx_client_email    INDEX     Q   CREATE UNIQUE INDEX idx_client_email ON ehotelschema.client USING btree (email);
 *   DROP INDEX ehotelschema.idx_client_email;
       ehotelschema              
   sashamilne    false    218            �           1259    33242    idx_hotel_chain    INDEX     K   CREATE INDEX idx_hotel_chain ON ehotelschema.hotel USING btree (chain_id);
 )   DROP INDEX ehotelschema.idx_hotel_chain;
       ehotelschema              
   sashamilne    false    220            �           2620    33239 !   client update_client_registration    TRIGGER     �   CREATE TRIGGER update_client_registration BEFORE UPDATE ON ehotelschema.client FOR EACH ROW EXECUTE FUNCTION public.update_registration_date();
 @   DROP TRIGGER update_client_registration ON ehotelschema.client;
       ehotelschema            
   sashamilne    false    218    224            �           2620    33241 &   reservation validate_reservation_dates    TRIGGER     �   CREATE TRIGGER validate_reservation_dates BEFORE INSERT OR UPDATE ON ehotelschema.reservation FOR EACH ROW EXECUTE FUNCTION public.check_reservation_dates();
 E   DROP TRIGGER validate_reservation_dates ON ehotelschema.reservation;
       ehotelschema            
   sashamilne    false    225    222            �           2606    33143    employee employee_works_at_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY ehotelschema.employee
    ADD CONSTRAINT employee_works_at_fkey FOREIGN KEY (works_at) REFERENCES ehotelschema.hotel(hotel_id);
 O   ALTER TABLE ONLY ehotelschema.employee DROP CONSTRAINT employee_works_at_fkey;
       ehotelschema            
   sashamilne    false    219    220    3478            �           2606    33148    hotel fk_manager    FK CONSTRAINT     �   ALTER TABLE ONLY ehotelschema.hotel
    ADD CONSTRAINT fk_manager FOREIGN KEY (manager_id) REFERENCES ehotelschema.employee(sin);
 @   ALTER TABLE ONLY ehotelschema.hotel DROP CONSTRAINT fk_manager;
       ehotelschema            
   sashamilne    false    219    3476    220            �           2606    33153    hotel hotel_chain_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY ehotelschema.hotel
    ADD CONSTRAINT hotel_chain_id_fkey FOREIGN KEY (chain_id) REFERENCES ehotelschema.hotel_chain(chain_id);
 I   ALTER TABLE ONLY ehotelschema.hotel DROP CONSTRAINT hotel_chain_id_fkey;
       ehotelschema            
   sashamilne    false    220    221    3481            �           2606    33158 (   reservation reservation_room_number_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY ehotelschema.reservation
    ADD CONSTRAINT reservation_room_number_fkey FOREIGN KEY (room_number) REFERENCES ehotelschema.room(room_number);
 X   ALTER TABLE ONLY ehotelschema.reservation DROP CONSTRAINT reservation_room_number_fkey;
       ehotelschema            
   sashamilne    false    223    3486    222            �           2606    33163     reservation reservation_sin_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY ehotelschema.reservation
    ADD CONSTRAINT reservation_sin_fkey FOREIGN KEY (sin) REFERENCES ehotelschema.client(sin);
 P   ALTER TABLE ONLY ehotelschema.reservation DROP CONSTRAINT reservation_sin_fkey;
       ehotelschema            
   sashamilne    false    218    3473    222            �           2606    33168    room room_hotel_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY ehotelschema.room
    ADD CONSTRAINT room_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES ehotelschema.hotel(hotel_id);
 G   ALTER TABLE ONLY ehotelschema.room DROP CONSTRAINT room_hotel_id_fkey;
       ehotelschema            
   sashamilne    false    220    3478    223            8   q   x���v
Q���WH��/I�)N�H�M�K��L�+Qs�	uV�0426153���QP/N,�HT2r3s�RA##S]c]c��K���+vH�M���K��U״��� ,�#<      9   k   x���v
Q���WH��/I�)N�H�M�K�-�ɯLMUs�	uV�0�QP����S�.�� *1%7����r���z)�����A���ML��-,�5���� �� �      :   R  x��X�r�H��+�6�
G����%[�-q%��`�� (�����6��5� `�*+3��f�����j6���uӇ�+�a�ߤ�������=�=#��a�"��-JOn+��������O�}�&��h��7���pE85R����BSK��Wն���������
o�����~f�p}��M��?\,�RL
I�Mۆ���m=���7D+=�5-�}jˮ�Oex>#��"�[��1�vV�x�T�.���b���g\u��8#o�� #����O2�k������:��H�i�r���о���N�i�m��䱬*�
�<ԙɵ�r�P�j�R����B'xg\k��������]����dF�;t,<��;t�����/��� ]N��ܦqi�����h�"��J�:�]���<��ZɎ�2��q�)5L�x�����/�px=��0dJ�a��Cl��w�0iB��;�|l��[?�\|~$�h�*��Y��7�_�n���f;�Jf�'�q�Tу���4�/�.SJ(7�E�ȵ߷�+��7{G����9p�rk�U�����P�]�Oh5�=#<�IIJ��-��#<ؕ�)��P�[߃:�Ob���t2JSN�a6��סڗ��g�eX�(J��z���m}ٖ�$
�	�)������c��j��L���<Į�O*�GH(��4ӎ���e�A6�� M�6,�p�cj�R�cdV����x��	��:����Q��}��u��N�Eh����4� LҦ"	%q�f4	�.�̪ن�t4G���KH9X_���`B�*L>�e�ط��6M�ʈ�tm/U���� r'-�Fd4�A(P�C�<� qx^xN�×�;jD�a+�J%@E�<�Ͳ-W��Lo��19IpK>�w�1��'��!+��/8�t)p�*�Dه�CݯKo�oh��8��f!��l����~і5F�jF|���W���d�W@Q/[��	�1aI��ʑԛ���ж�8�q�����ue��\�)O�Ƥ�����ž��p��=aӘ�3���*��3�Aj�}��6T�����|7{$\X��S+���4]�z*��o(���u����*-�J�ue�,"tDwTΫ)�B�T:�k.u�\�f��[_�OC�x.��ڂU�_��.�R���<�uʞqa�!0�"�a
/LF����hu�t e@82��h�y�_d4B����u6ei���1�Gq�v�uN8"�q6p�Rr��uhv#�S83�<{�ch��,�'O!�"�(㌠,!��>�SC�U���JrQ�T�f�vG��V9 ���ж$�)�5	Lei�o���g��81�
K��b�����r_��ZI5y�X����rzsE$�G���i����gF�C�e|.4�lêAL�����l�ɏR1��W�ߢ�`�Ü@R��X���Lfo�K�hVA�O�6�a*CS,-`WM�7��?k͎����:<'l�APVi�i�-�Y�ڔ[ċ� �oXu���ar����p|�>֘[�������<�����BI��������񻿁qfh�s�B^�����5r� Qj��s���r��!�a���Mfģh�����˙��1���(��Y3��KN^]�iEY'$w����m�~�����dFg]/rзa$�ܔ=n��Po?��-KD��r&,�(^}�N�~��p(�*r�>rW.W�;�=�<{x�9�
)��*9G� g�fMU-ڦٜ"Q(�d��"��ɥo_��"DS.K+�N"��)�>��z�zg	q������y�U�����6,M��W^W��25�]X��r���=z������'D������Gð���1�8���!N+N�V��'���8�Q^,{}�2C��">@
��BW����a=�U
���,w_,#:������C`k&S?#Wuu<ٓFҙ��n]�Q;g��=6i'�z"������8=T��xZ#�\7���i�ڜ�~t)m^,��5	6�v�t
�q�KϘ����&���t������㻇�j�<$e�.N�x��r͞�}��:�y6�q�����z��.��2W�m�X`o��e^Ln�T�|�j�,�P�oS����X��f�6bi>��C��M$d~Q�<V����M&�^�      ;      x����K�@���+�)�l�X�`�M%��(�f$������IJ�G���y��1���8A�����j�1��[����LH����w%���&I��Y���ѶG�NLն$� ��u�I=r�)x��W����N�h0vF	�O��R�h1aK�-�ə�3S� ږM��#������H�U�#����s��Qm�N�MH�M{&G��hZ%I�ؐ\=�0cz�Ca߫�PVP(VQ���{�����-�q� E*�6      <   
   x���          =   
   x���         